# FreeRADIUS + PostgreSQL — Docker

Infraestrutura de autenticação RADIUS com banco de dados PostgreSQL,
orquestrada via Docker Compose e gerenciada pelo Portainer.

## Estrutura do projeto

.
├── docker-compose.yml
├── dockerfile.freeradius
├── dockerfile.postgres
├── entrypoint.freeradius.sh
├── .env
├── freeradius
│   ├── clients.conf
│   ├── mods-available
│   │   ├── sql
│   │   └── sqlippool
│   ├── radiusd.conf
│   └── sites-enabled
│       └── default
├── init
│   ├── 01-create-database.sh
│   └── schema.sql
└── README.md


## Variáveis de ambiente

Copie as variáveis abaixo para um arquivo `.env` na raiz do projeto e preencha com os valores adequados ao seu ambiente.

|           Variável            |                       Descrição           |          Exemplo      |
|-------------------------------|-------------------------------------------|-----------------------|
| **PORTAINER**                 |                                           |                       |
| `PORTAINER_PORT`              | Porta HTTPS do Portainer                  | `9443`                |
| `PORTAINER_PORT2`             | Porta HTTP legada do Portainer            | `9000`                |
| `PORTAINER_ADDRESS`           | IP fixo do container Portainer na rede    | `172.20.0.2`          |
| **POSTGRESQL**                |                                           |                       |
| `POSTGRES_USER_DEFAULT`       | Usuário padrão do Postgres                | `postgres`            |
| `POSTGRES_PASSWORD_DEFAULT`   | Senha do usuário padrão                   | `sua_senha`           |
| `DATABASE`                    | Nome do banco de dados                    | `freeradius`          |
| `POSTGRES_ADDRESS`            | IP fixo do container Postgres             | `172.20.0.3`          |
| `POSTGRES_PORT`               | Porta exposta do Postgres                 | `5432`                |
| **FreeRADIUS**                |                                           |                       |
| `FREERADIUS_USER_DEFAULT`     | Usuário do banco para o FreeRADIUS        | `frd_user`            |
| `FREERADIUS_PASSWORD_DEFAULT` | Senha do usuário FreeRADIUS               | `frd_senha`           |
| `FREERADIUS_ADDRESS`          | IP fixo do container FreeRADIUS           | `172.20.0.4`          |
| **GLOBAL CONFIG**             |                                           |                       |
| `FREERADIUS_NETWORK`          | Sub-rede da network customizada           | `172.20.0.0/16`       |
| `NETWORK_GATEWAY`             | Gateway da rede                           | `172.20.0.1`          |
| `TZ`                          | Fuso horário dos containers               | `America/Sao_Paulo`   |

> **Atenção:** se alterar `FREERADIUS_NETWORK` / `NETWORK_GATEWAY` (ex.: `192.168.0.0/24`),
> atualize também todos os `*_ADDRESS` para IPs dentro da nova faixa.
> O arquivo env-copy.txt possui todas as variáveis necessárias, preencha-o e renomeie para .env

## Como subir

```bash
# 1. Crie o arquivo .env com suas variáveis
nano .env   # (env-copy.txt) 

# 2. Deploy 
docker compose up --build -d   

# 3. Para remover (exceto images)
docker compose down -v