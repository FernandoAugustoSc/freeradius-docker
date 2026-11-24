# FreeRADIUS, PostgreSQL e Monitoramento — Docker

## Visão geral

Este projeto fornece uma infraestrutura de autenticação e contabilização baseada em
RADIUS, executada integralmente em containers Docker. O componente principal é o
FreeRADIUS, responsável por receber solicitações de autenticação e contabilização
dos equipamentos de rede, verificar as credenciais e políticas armazenadas no
PostgreSQL e registrar informações sobre sessões dos usuários.

A solução foi criada para estudos e ambientes de laboratório. Além dos serviços
essenciais de RADIUS e banco de dados, o ambiente também inclui Zabbix e Grafana
para coleta e visualização de dados de monitoramento, e Portainer para administração
gráfica dos containers.

## Arquitetura

- **FreeRADIUS:** serviço de autenticação RADIUS que usa o protocolo PostgreSQL para
  consultar usuários, grupos, permissões e registros de sessão.
- **PostgreSQL:** banco central usado pelo FreeRADIUS. Na inicialização, a imagem
  cria o banco configurado, aplica o esquema RADIUS e cria um usuário com permissões
  limitadas às tabelas utilizadas pelo servidor.
- **Zabbix Server:** recebe dados de monitoramento dos agentes e comunica-se com o
  PostgreSQL para armazená-los.
- **Zabbix Web:** interface web do Zabbix publicada na porta configurada por
  `ZABBIX_WEB_PORT`.
- **Zabbix Agent:** coleta métricas e informações do host onde opera.
- **Grafana:** interface para criação de painéis e visualização dos dados fornecidos
  pelo Zabbix.
- **Portainer:** interface web para gerenciar containers, imagens, volumes e redes
  Docker.

## Descrição dos arquivos do projeto

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

|           Variável            |                Descrição                  |       Exemplo         |
|-------------------------------|-------------------------------------------|-----------------------|
| **PORTAINER**                 |                                           |                       |
| `PORTAINER_PORT`              | Porta HTTPS do Portainer                  | `9443`                |
| `PORTAINER_PORT2`             | Porta HTTP legada do Portainer            | `9000`                |
| `PORTAINER_ADDRESS`           | IP fixo do container                      | `172.20.0.2`          |
|-------------------------------|-------------------------------------------|-----------------------|
| **POSTGRESQL**                |                                           |                       |
| `DATABASE`                    | Nome do banco de dados                    | `freeradius`          |
| `POSTGRES_PORT`               | Porta exposta do Postgres                 | `5432`                |
| `POSTGRES_ADDRESS`            | IP fixo do container                      | `172.20.0.3`          |
| `POSTGRES_USER_DEFAULT`       | Usuário padrão do Postgres                | `postgres`            |
| `POSTGRES_PASSWORD_DEFAULT`   | Senha do usuário padrão                   | `sua_senha`           |
|-------------------------------|-------------------------------------------|-----------------------|
| **FreeRADIUS**                |                                           |                       |
| `FREERADIUS_ADDRESS`          | IP fixo do container FreeRADIUS           | `172.20.0.4`          |
| `FREERADIUS_USER_DEFAULT`     | Usuário do banco para o FreeRADIUS        | `frd_user`            |
| `FREERADIUS_PASSWORD_DEFAULT` | Senha do usuário FreeRADIUS               | `frd_senha`           |
|-------------------------------|-------------------------------------------|-----------------------|
| **ZABBIX SERVER**             |                                           |                       |
| `ZABBIX_SERVER_ADDRESS`       | IP fixo do container                      | `172.20.0.5`          |
| `ZABBIX_DATABASE`             | Database do Zabbix dentro do Postgre      | `zabbix`              |
|-------------------------------|-------------------------------------------|-----------------------|
| **ZABBIX WEB**                |                                           |                       |
| `ZABBIX_WEB_ADDRESS`          | IP fixo do container                      | `172.20.0.6`          |
| `ZABBIX_WEB_PORT`             | Porta de acesso do Zabbix                 | `8080`                |
|-------------------------------|-------------------------------------------|-----------------------|
| **ZABBIX AGENT**              |                                           |                       |
| `ZABBIX_AGENT_ADDRESS`        | IP fixo do container                      | `172.20.0.7`          |
| `ZBX_HOSTNAME`                | Nome do agent                             | `zabbix-agent`        |
|-------------------------------|-------------------------------------------|-----------------------|
| **GRAFANA**                   |                                           |                       |
| `GRAFANA_ADDRESS`             | IP fixo do container                      | `172.20.0.8`          |
|-------------------------------|-------------------------------------------|-----------------------|
| **GLOBAL CONFIG**             |                                           |                       |
| `TZ`                          | Fuso horário dos containers               | `America/Sao_Paulo`   |
| `NETWORK_GATEWAY`             | Gateway da rede                           | `172.20.0.1`          |
| `FREERADIUS_NETWORK`          | Sub-rede da network customizada           | `172.20.0.0/16`       |
|-------------------------------|-------------------------------------------|-----------------------|

**ORIENTAÇÕES:**

## 1.
> Case necessite alterar as variáveis `FREERADIUS_NETWORK` / `NETWORK_GATEWAY` (ex.: `192.168.0.0/24`),
> lembre-se de alterar também todos os `*_ADDRESS` para IPs dentro da nova faixa.

## 2.
> Todos os containers necessitam de um IP fixo, caso não queria utilizar IP fixo, basta reajustar o projeto. Mas recomenda-se manter o banco de dados com IP fixo.

## 3.
> O arquivo env-copy.txt possui todas as variáveis necessárias, preencha as variáveis e renomeio
> o arquivo para .env antes de executar o deploy.

# Como subir

## 2. Deploy 
docker compose up --build -d   

## 3. Para remover network, containers e volumes 
docker compose down -v

## 4. Para remover apenas containers e network
docker compose down