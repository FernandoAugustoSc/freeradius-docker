# FreeRADIUS + PostgreSQL — Docker

Infraestrutura de autenticação RADIUS com banco de dados PostgreSQL,
orquestrada via Docker Compose e gerenciada pelo Portainer.

## Estrutura do projeto

.
├── docker-compose.yml
├── dockerfile.freeradius
├── dockerfile.postgres
├── entrypoint.sh
├── .env
├── freeradius/
│ ├── certs/
│ │ ├── server.crt
│ │ └── server.key
│ ├── clients.conf
│ ├── mods-available/
│ │ ├── sql
│ │ └── sqlippool
│ ├── radiusd.conf
│ └── sites-enabled/
│ └── default
├── init/
│ ├── 01-schema.sql
│ └── 02-create-user.sh
└── README.md


## Variáveis de ambiente

Copie as variáveis abaixo para um arquivo `.env` na raiz do projeto e preencha com os valores adequados ao seu ambiente.

|           Variável            |                       Descrição           |      Exemplo      |
|-------------------------------|-------------------------------------------|-------------------|
| **Portainer**                 |                                           |                   |
| `PORTAINER_PORT`              | Porta HTTPS do Portainer                  | `9443`            |
| `PORTAINER_PORT2`             | Porta HTTP legada do Portainer            | `9000`            |
| `PORTAINER_CT_ADDRESS`        | IP fixo do container Portainer na rede    | `172.20.0.2`      |
| **PostgreSQL**                |                                           |                   |
| `POSTGRES_USER_DEFAULT`       | Usuário padrão do Postgres                | `postgres`        |
| `POSTGRES_PASSWORD_DEFAULT`   | Senha do usuário padrão                   | `sua_senha`       |
| `POSTGRES_DB`                 | Nome do banco de dados                    | `freeradius`      |
| `POSTGRES_CT_ADDRESS`         | IP fixo do container Postgres             | `172.20.0.3`      |
| `POSTGRES_PORT`               | Porta exposta do Postgres                 | `5432`            |
| **FreeRADIUS**                |                                           |                   |
| `FRD_HOST_DB`                 | Host do banco (IP do Postgres)            | `172.20.0.3`      |
| `FRD_USER`                    | Usuário do banco para o FreeRADIUS        | `frd_user`        |
| `FRD_PASSWORD`                | Senha do usuário FreeRADIUS               | `frd_senha`       |
| `FRD_NAME_DB`                 | Nome do banco                             | `freeradius`      |
| `FRD_PORT_DB`                 | Porta do banco                            | `5432`            |
| `FRD_CT_ADDRESS`              | IP fixo do container FreeRADIUS           | `172.20.0.4`      |
| **Docker**                    |                                           |                   |
| `DCK_NETWORK`                 | Sub-rede da network customizada           | `172.20.0.0/16`   |
| `DCK_GATEWAY`                 | Gateway da rede                           | `172.20.0.1`      |

> **Atenção:** se alterar `DCK_NETWORK` / `DCK_GATEWAY` (ex.: `192.168.0.0/24`),
> atualize também todos os `*_CT_ADDRESS` para IPs dentro da nova faixa.

## Como subir

```bash
# 1. Crie o .env com suas variáveis
cp .env.example .env   # (se existir) ou crie manualmente

# 2. Suba a stack
docker compose up --build -d   

# 3. Para remover a stack (exceto images)
docker compose down -v