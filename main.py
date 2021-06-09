from fastapi import FastAPI

DATA = [
    { 'domain': 'modernisation.gouv.fr', 'administration_type': 'ministere', 'SIRET': '1234567'},
    { 'domain': 'dinum.gouv.fr', 'administration_type': 'interministériel', 'SIRET': '09887765'}
  ]


app = FastAPI()

@app.get('/')
async def get_root():
  return { 'content': 'coucou coucou' }

@app.get('/domain/{name}')
async def get_domain(name: str):
  for entry in DATA:
    if entry.get('domain') == name:
      return entry
  return { 'error': 'domain not found' }

