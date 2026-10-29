
# FreeRADIUS Docker

Infraestrutura de autenticação RADIUS com Docker Compose.



## Estrutura

.
├── docker-compose.yml
├── .env
├── freeradius
│   ├── certs
│   │   ├── server.crt
│   │   └── server.key
│   ├── clients.conf
│   ├── entrypoint.sh
│   ├── mods-available
│   │   ├── sql
│   │   └── sqlippool
│   ├── radiusd.conf
│   └── sites-enabled
│       ├── default -> ../sites-available/default
│       └── inner-tunnel -> ../sites-available/inner-tunnel
├── init
    ├── 01-schema.sql
    └── 02-create-user.sh


## Variáveis de ambiente

Crie um arquivo `.env` e preencha os dados como desejar:

# Banco de dados

POSTGRES_USER_DEFAULT=
POSTGRES_PASSWORD_DEFAULT=
POSTGRES_DB=

# FreeRADIUS

FRD_HOST_DB=
FRD_USER=
FRD_PASSWORD=
FRD_NAME_DB=