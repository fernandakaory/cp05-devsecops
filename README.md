# CP05 — Pipeline DevSecOps | Arcanjosa

Projeto desenvolvido para o **Checkpoint 05 — DevSecOps and Cloud Computing**

## Objetivo

Implementar um pipeline de segurança automatizado para o portal **Arcanjosa**, reaproveitando a aplicação HTML containerizada no CP04. O pipeline utiliza **GitHub Actions** para executar análises de segredos, código-fonte e imagem Docker a cada *push* ou *pull request*.

Além de configurar as ferramentas, o checkpoint inclui **testes controlados de sabotagem** para demonstrar a detecção e o bloqueio de falhas de segurança.

## Tecnologias e ferramentas

| Tecnologia | Utilização |
|---|---|
| HTML e CSS | Portal web da Arcanjosa |
| Docker e Nginx | Containerização e disponibilização do site |
| GitHub Actions | Automação do pipeline de CI |
| Gitleaks | Identificação de credenciais expostas no repositório |
| Semgrep | Análise estática de código (SAST) |
| Trivy | Análise de vulnerabilidades conhecidas (CVEs) na imagem Docker |

## Estrutura do projeto

```text
cp05-devsecops/
├── .github/
│   └── workflows/
│       └── security.yml
├── .semgrep.yml
├── Dockerfile
├── index.html
└── README.md
```

- **`index.html`**: página do portal Arcanjosa, reutilizada do CP04.
- **`Dockerfile`**: define a imagem com Nginx para servir o site.
- **`.github/workflows/security.yml`**: configura os jobs do GitHub Actions.
- **`.semgrep.yml`**: contém a regra utilizada na demonstração de detecção da função `eval()`.

## Como executar o site localmente

**Pré-requisito:** Docker instalado e em execução.

Na raiz do projeto, construa a imagem:

```bash
docker build -t arcanjosa:v1 .
```

Crie e inicie o container:

```bash
docker run -d --name arcanjosa -p 8080:80 arcanjosa:v1
```

Acesse **http://localhost:8080** no navegador.

Comandos úteis:

```bash
docker ps                 # Ver containers em execução
docker stop arcanjosa     # Parar o container
docker start arcanjosa    # Iniciar novamente
docker logs arcanjosa     # Consultar logs
```

Se o nome `arcanjosa` já estiver em uso, verifique o container existente com `docker ps -a` antes de tentar criá-lo novamente.

## Pipeline de segurança

O workflow **Security Pipeline** é acionado por *push* e *pull request* e possui três jobs:

1. **Gitleaks — Secret Scanning:** busca segredos e credenciais potencialmente expostos no histórico do repositório.
2. **Semgrep — SAST:** analisa o código-fonte. Para a prova do checkpoint, foi configurada uma regra personalizada para sinalizar o uso de `eval()` em JavaScript.
3. **Trivy — Container Security:** constrói a imagem `arcanjosa:v1` e verifica vulnerabilidades conhecidas. A configuração do checkpoint considera a severidade **CRITICAL**, com código de saída `1` quando encontra vulnerabilidades desse nível.

O status e os logs de cada verificação podem ser consultados em **GitHub → Actions → Security Pipeline**.

## Testes de validação

Os testes foram realizados em branches específicas, sem incorporar os arquivos vulneráveis à branch principal.

| Teste | Branch | Simulação | Resultado observado |
|---|---|---|---|
| Gitleaks | `teste-gitleaks` | Inclusão de credencial AWS **fictícia** em `config.js` | Credencial identificada e job bloqueado |
| Semgrep | `teste-semgrep` | Inclusão de chamada `eval()` em `vulneravel.js` | Regra `javascript-eval-inseguro` acionada; job finalizado com *exit code* 1 |
| Trivy — imagem original | `main` | Verificação da imagem `arcanjosa:v1` | Nenhuma vulnerabilidade crítica reportada; job aprovado |
| Trivy — sabotagem | `teste-trivy` | Inclusão controlada de `log4j-core 2.14.1`, associado à **CVE-2021-44228**, na imagem | Vulnerabilidades críticas identificadas e job bloqueado |

**Atenção:** os arquivos e dependências vulneráveis servem apenas para testes acadêmicos. Não devem permanecer na versão principal nem ser utilizados em produção. A análise limpa do Trivy indica ausência de achados **no escopo e na base de dados analisados**, não garantia de segurança absoluta.

## Evidências e documentação

A documentação do checkpoint reúne capturas da criação da imagem e do container, execução do portal em `localhost:8080`, configuração do workflow e resultados dos testes realizados no GitHub Actions, com explicações sobre os riscos identificados.

## Considerações finais

A atividade demonstra o conceito de **Shift Left**, incorporando verificações de segurança ao processo de desenvolvimento. Os testes comprovaram que o pipeline consegue detectar credenciais expostas, apontar código potencialmente inseguro e impedir a aprovação de imagens com vulnerabilidades críticas detectadas, de acordo com as regras configuradas.

## Equipe

- Fernanda Kaory Saito — RM 551104
- João Pedro Borsato — RM 550294
- Maria Fernanda Camargo — RM 97956
- Pedro Lucas Nunes — RM 550366
- Vinicius Bernardino — RM 97888

**FIAP — Engenharia de Software | 2026**
