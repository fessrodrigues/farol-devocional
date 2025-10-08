# ADR-003: Estratégia de Branching e Fluxo de Trabalho (Git)

* **Status:** Aceito
* **Data:** 2025-10-07

## Contexto

Para organizar o desenvolvimento e o processo de deploy, era necessária uma estratégia de branching no Git. O modelo GitFlow completo (com branches `feature`, `develop`, `release`, `hotfix` e `main`) foi considerado por ser um padrão robusto da indústria. No entanto, para a fase inicial de um projeto com um único desenvolvedor, a complexidade e a burocracia das branches `release` foram consideradas um potencial obstáculo à agilidade.

## Decisão

Adotaremos o padrão **"GitFlow Simplificado"** para a fase de MVP.

* **`main`:** Branch protegida que reflete o código em Produção.

* **`develop`:** Branch padrão do repositório, reflete o estado de integração contínua e será a base para o ambiente de Homologação.

* **`feature/*`:** Branches para desenvolvimento de novas funcionalidades, criadas a partir da `develop`. O merge de volta para a `develop` será feito obrigatoriamente via Pull Request.

A implementação de branches `release/*` será registrada como uma dívida técnica no backlog, a ser reavaliada quando o projeto atingir maior maturidade ou houver múltiplos contribuidores.

## Consequências

### Positivas
* O fluxo de trabalho é ágil e otimizado para a entrega rápida de features.
* A estrutura é simples de entender e gerenciar, reduzindo a carga cognitiva.
* A obrigatoriedade de Pull Requests para `develop` e `main` garante a execução do pipeline de CI e a possibilidade de revisão de código.

### Negativas
* O processo de versionamento formal (ex: preparar a versão `v1.1.0`) é menos estruturado. Este é um trade-off aceitável para as fases iniciais do projeto.