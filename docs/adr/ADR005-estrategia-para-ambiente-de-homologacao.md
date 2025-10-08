# ADR-005: Estratégia para o Ambiente de Homologação

* **Status:** Aceito
* **Data:** 2025-10-07

## Contexto

É essencial ter um ambiente de homologação ("staging") para validar novas funcionalidades antes de serem integradas ao código principal e, eventualmente, irem para produção. A abordagem tradicional seria criar um segundo serviço persistente, com um link fixo. 

Com a escolha da plataforma única (conforme ADR-004), é necessário definir a estratégia para a segregação dos ambientes de Produção e Homologação, alinhada à nossa estratégia de GitFlow Simplificado. O objetivo é ter um ambiente para validar a branch `develop` e outro para servir o tráfego de produção a partir da branch `main`, ambos operando de forma isolada dentro do mesmo projeto.

## Decisão

Criaremos **dois serviços separados** dentro do mesmo projeto para representar nossos ambientes:

1.  **Serviço de Homologação:**
    * **Nome do Serviço:** `farol-devocional-homol`
    * **Gatilho de Deploy:** O pipeline de CD será configurado para implantar automaticamente neste serviço a cada `push` na branch `develop`.
    * **Propósito:** Servir como um ambiente de integração contínua e testes manuais, com um endpoint fixo para validação.

2.  **Serviço de Produção:**
    * **Nome do Serviço:** `farol-devocional-prod`
    * **Gatilho de Deploy:** O pipeline de CD será configurado para implantar neste serviço a cada `push` na branch `main`.
    * **Controle:** O pipeline de CI/CD no GitHub Actions utilizará um "Environment" de produção que exigirá **aprovação manual** antes do deploy, simulando um processo formal de change management.

## Consequências

### Positivas
* O isolamento entre os ambientes é total, com URLs, configurações, segredos e revisões independentes.
* A estratégia se alinha perfeitamente com o nosso pipeline de `cd.yml`, que terá um job para cada ambiente, disparado pela respectiva branch.
* A criação de um ambiente de homologação com link fixo atende à necessidade de testes por terceiros de forma simples e direta.

### Negativas
* A gestão de dois serviços, embora no mesmo projeto, requer atenção para garantir que as configurações de recursos (CPU, memória) se mantenham consistentes, exceto onde uma diferenciação for intencional.