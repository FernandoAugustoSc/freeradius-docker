
# FreeRADIUS Docker

Infraestrutura de autenticação FreeRadius e Postgres em ambiente Docker.

## Estrutura

.
└── freeradius
    ├── docker-compose.yml
    ├── dockerfile.freeradius
    ├── dockerfile.postgres
    ├── entrypoint.sh
    ├── freeradius
    │   ├── certs
    │   │   ├── server.crt
    │   │   └── server.key
    │   ├── clients.conf
    │   ├── mods-available
    │   │   ├── sql
    │   │   └── sqlippool
    │   ├── radiusd.conf
    │   └── sites-enabled
    │       └── default
    ├── init
    │   ├── 01-schema.sql
    │   └── 02-create-user.sh


## Variáveis de ambiente {

#Banco de dados

POSTGRES_USER_DEFAULT=
POSTGRES_PASSWORD_DEFAULT=
POSTGRES_DB=

#FreeRADIUS

FRD_HOST_DB=
FRD_USER=
FRD_PASSWORD=
FRD_NAME_DB=

# }


Lembre-se de criar o arquivo .env com as variáveis do seu projeto

# Para iniciar o projeto, execute:

docker compose up --build -d
