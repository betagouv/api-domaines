# API Domaines

Un api pour servir les données du référentiel des domaines des administrations.

Voir le data des domaines : https://github.com/betagouv/domaines-data

## Installation
 - set up your python virtual env
 - install dependencies :
```
pip install -r requirements.txt
```
 - run server :
 ```
 uvicorn main:app
 ```

If you want a dev server which reloads when you edit files :
```
uvicorn main:app --reload
```

## Queries
`GET http://localhost:8000/` : welcome message

`GET http://localhost:8000/docs` : API doc and playground to try out queries

`GET http://localhost:8000/domain/dinum.gouv.fr` : look up the data for the domain "dinum.gouv.fr"


## Troubleshooting
Error : `pkg_resources.DistributionNotFound: The 'uvicorn' distribution was not found and is required by the application`

-> use `./<your env name>/bin/uvicorn main:app --reload`

(todo figure out PYTHONPATH instead ?)

## Licence
MIT