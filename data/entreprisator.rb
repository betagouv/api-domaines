# Enrich data from input.csv with data from API Entreprises
#
# How to run :
# install ruby, and rails
# rails runner ./data/entreprisator.rb
require "csv"

INPUT_FILE = "./input.csv"
OUTPUT_FILE = "./output.csv"
codes_naf = JSON.parse(File.read("./public/codes_naf.json"))
categories_juridiques = JSON.parse(File.read("./public/categories_juridiques_20200701.json"))

output_file = CSV.open(OUTPUT_FILE, "w")
output_file << %w[siret email_domain activite_principale activite_principale_label categorie_juridique categorie_juridique_label]

puts "Exporting enrollments..."

CSV.foreach(INPUT_FILE, headers: true, strip: true, liberal_parsing: true) do |row|
  sleep 0.75
  # Mind that the usage of API v3 was not tested.
  # There might be unwanted concurrency issues.
  response = HTTP.get("https://entreprise.data.gouv.fr/api/sirene/v3/etablissements/#{row["siret"]}")
  unless response.status.success? && response.parse["etablissement"]["etat_administratif"] == "A"
    puts "\e[31m#{row["siret"]} not found!\e[0m"
    next
  end

  puts "Processing #{row["siret"]}..."
  activite_principale = response.parse["etablissement"]["activite_principale"]
  activite_principale ||= response.parse["etablissement"]["unite_legale"]["activite_principale"]
  activite_principale_label = codes_naf[activite_principale.delete(".")]
  categorie_juridique = response.parse["etablissement"]["unite_legale"]["categorie_juridique"]
  categorie_juridique_label = categories_juridiques[categorie_juridique]
  nom_raison_sociale = response.parse["etablissement"]["unite_legale"]["denomination"]
  nom_raison_sociale ||= response.parse["etablissement"]["denomination_usuelle"]
  nom = response.parse["etablissement"]["unite_legale"]["nom"]
  prenom_1 = response.parse["etablissement"]["unite_legale"]["prenom_1"]
  prenom_2 = response.parse["etablissement"]["unite_legale"]["prenom_2"]
  prenom_3 = response.parse["etablissement"]["unite_legale"]["prenom_3"]
  prenom_4 = response.parse["etablissement"]["unite_legale"]["prenom_4"]
  nom_raison_sociale ||= "#{nom + "*" unless nom.nil?}#{prenom_1 unless prenom_1.nil?}#{" " + prenom_2 unless prenom_2.nil?}#{" " + prenom_3 unless prenom_3.nil?}#{" " + prenom_4 unless prenom_4.nil?}"
  puts "#{row["siret"]} - #{nom_raison_sociale}"

  output_file << [
    row["siret"],
    row["email_domain"],
    activite_principale,
    activite_principale_label,
    categorie_juridique,
    categorie_juridique_label
  ]
end

puts "finito"
