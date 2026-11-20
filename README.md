# FreeRADIUS + PostgreSQL — Docker

Infraestrutura de autenticação FreeRADIUS com banco de dados PostgreSQL,
orquestrada via Docker e com gerenciamento web feito atraves do Portainer-EE.


## Descrição dos arquivos do Projeto

- `docker-compose.yml`: define e orquestra os containers do FreeRADIUS, PostgreSQL e Portainer, incluindo portas, rede, variáveis de ambiente e verificações de saúde.
- `dockerfile.freeradius`: cria a imagem do FreeRADIUS, copia as configurações, script de inicialização, prepara o módulo SQL e os certificados.
- `dockerfile.postgres`: cria a imagem do PostgreSQL e inclui os scripts de inicialização e configuração do banco.
- `entrypoint.freeradius.sh`: substitui os placeholders de conexão com o banco pelas variáveis de ambiente e inicia a coleta de logs.
- `env-copy.txt`: modelo com as variáveis necessárias para criar o arquivo `.env`.
- `freeradius/mods-available/sql`: configura o módulo SQL do FreeRADIUS para conectar ao PostgreSQL e consultar as tabelas RADIUS.
- `freeradius/radiusd.conf`: contém as configurações gerais do servidor FreeRADIUS.
- `freeradius/sites-enabled/default`: define o servidor virtual padrão e os fluxos de autenticação e contabilização das requisições.
- `postgres/01-create-database.sh`: cria o banco de dados, aplica o esquema e cria o usuário do FreeRADIUS com as permissões necessárias.
- `postgres/schema.sql`: define as tabelas e os índices usados pelo FreeRADIUS para autenticação e contabilização .

## Estrutura do projeto

.
├── .env
├── docker-compose.yml
├── dockerfile.freeradius
├── dockerfile.postgres
├── env-copy.txt
├── entrypoint.freeradius.sh
├── freeradius
│   ├── clients.conf
│   ├── mods-available
│   │   └── sql
│   ├── radiusd.conf
│   └── sites-enabled
│       └── default
├── postgres
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
| `DATABASE`                    | Nome do banco de dados                    | `freeradius`          |
| `POSTGRES_PORT`               | Porta exposta do Postgres                 | `5432`                |
| `POSTGRES_ADDRESS`            | IP fixo do container Postgres             | `172.20.0.3`          |
| `POSTGRES_USER_DEFAULT`       | Usuário padrão do Postgres                | `postgres`            |
| `POSTGRES_PASSWORD_DEFAULT`   | Senha do usuário padrão                   | `sua_senha`           |
| **FreeRADIUS**                |                                           |                       |
| `FREERADIUS_ADDRESS`          | IP fixo do container FreeRADIUS           | `172.20.0.4`          |
| `FREERADIUS_USER_DEFAULT`     | Usuário do banco para o FreeRADIUS        | `frd_user`            |
| `FREERADIUS_PASSWORD_DEFAULT` | Senha do usuário FreeRADIUS               | `frd_senha`           |
| **GLOBAL CONFIG**             |                                           |                       |
| `TZ`                          | Fuso horário dos containers               | `America/Sao_Paulo`   |
| `NETWORK_GATEWAY`             | Gateway da rede                           | `172.20.0.1`          |
| `FREERADIUS_NETWORK`          | Sub-rede da network customizada           | `172.20.0.0/16`       |

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