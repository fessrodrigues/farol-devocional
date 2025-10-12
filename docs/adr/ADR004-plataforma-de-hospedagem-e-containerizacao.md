# ADR-004: Plataforma de Hospedagem e Estratégia de Containerização

* **Status:** Em análise
* **Data:** 2025-10-07

## Contexto

AA seleção da plataforma de nuvem é uma decisão fundamental que impacta custo, performance, complexidade e o fluxo de trabalho de CI/CD. Diversas opções foram consideradas, dentre as principais uso 100% no Render, uma abordagem híbrida Render+ , Render + GCP, 100% Azure e 100% GCP. Cada opção apresentava trade-offs significativos. A principal restrição é a necessidade de operar em uma camada mais robusta possível que menor custo, com suporte a contêineres Docker e que permitisse a segregação de ambientes de Produção e Homologação.

Acerca dos limites atuais para cada plataforma:

    * Render - Plano Hobby (Gratuito):
        - Instâncias: 1 instância/projeto por conta.
        - Tempo de Atividade: 750 horas de build e 750 horas de execução por mês (compartilhadas).
        - Memória: 512 MB.
        - CPU: 0.1 vCPU.
        - Cold Start - serviço é suspenso após 15 minutos de inatividade, com tempo de retorno estimado em 50 segundos.

    * Google Cloud Plataform - Cloud Run ("Always Free"):
        - Requisições: 2 milhões/mês
        - Memória: 360.000 GiB-segundos/mês
        - CPU: 180.000 vCPU-segundos/mês
        - Cold Start - serviço é suspenso por inatividade, mas o tempo de retorno é estimado em 1 segundo.

    * Azure: 
        Functions (Plano de Consumo - Gratuito):
        - Requisições: 1 milhão/mês
        - Tempo de Execução: 400.000 GB-segundos/mês
        - Ideal para trechos de código pequenos e reativos (serverless). Cold Start variável, mas geralmente rápido para funções simples.

        App Service (Plano Gratuito - F1):
        - Instâncias: 1 instância compartilhada.
        - Memória: 1 GB.
        - CPU: Compartilhada.
        - Hospedagem de aplicações web completas. Cold Start presente, mas com tempo de retorno geralmente menor que o Render.

Cenários estimados:

    Requisições: ~90.000 req/mês (~3.000 req/dia)

    CPU e Memória (A Análise Crítica):
        Estimativa de pico em 15 req/min.

        Uma requisição para a IA pode levar 20 segundos a depender do modelo escolhido. Se a CPU ficasse alocada durante todo esse tempo, nosso consumo seria 90.000 requisições * 20 segundos = 1.800.000 vCPU-segundos. Isso estouraria as cotas de processamento.

        O Google Cloud Run tem uma configuração de alocação de CPU. Por padrão, a CPU só é alocada enquanto o seu código está ativamente processando dados. Durante a maior parte desses 20 segundos, nossa aplicação estará apenas esperando a resposta da API do Gemini (uma operação de I/O). Durante o I/O, o Cloud Run não aloca (e não cobra pela) CPU.

        O processamento real do nosso código (receber a requisição, montar o prompt, tratar a resposta) levará, talvez, 1 a 2 segundos por requisição. Com isso, nosso consumo seria de 90.000 requisições * 2 segundo = 180.000 vCPU-segundos. Caso fosse escolhida a GCP, estaremos no limite porém atendendo satisfatoriamente.

## Decisão

Uma premissa é que adotaremos a **containerização da aplicação com Docker** para possibilitar melhor portabilidade. 

O projeto será hospedado inicialmente no Render para as fases de desenvolvimento e primeiros MVPs. APós amadurecimento das entregas, migraremos para o **Google Cloud Platform (GCP)**, utilizando o **Google Cloud Run** para todos os ambientes (Produção e Homologação).

A decisão de unificar a plataforma foi tomada priorizando o princípio de **Paridade de Ambientes (Environment Parity)**, um pilar de DevOps que garante a máxima consistência entre o que é testado e o que é implantado em produção. Embora a curva de aprendizado inicial do GCP seja maior que a de plataformas PaaS mais simples, os benefícios a longo prazo de uma infraestrutura homogênea, performática e escalável superam a conveniência inicial.

O Render foi escolhido para a fase inicial por ser de fácil configuração e atender satisfatoriamente as premissas. SUas vantagens são, mas não limitadas a: 
1.  **Facilidade de Uso:** Interface intuitiva e configuração simplificada, permitindo um deploy rápido e sem a necessidade de grande conhecimento em infraestrutura.
2.  **Foco no Desenvolvimento:** Permite que o desenvolvedor se concentre na lógica de negócio da aplicação, abstraindo a complexidade da infraestrutura.
3.  **Ambiente de Teste Rápido:** Ideal para validar funcionalidades e coletar feedback inicial de forma ágil.

O Google Cloud Run foi escolhido como plataforma única por:
1.  **Modelo Serverless:** Sua arquitetura "scale-to-zero" e camada gratuita generosa garantem a viabilidade do custo zero.
2.  **Performance:** Oferece um tempo de "cold start" para contêineres Java superior às alternativas de PaaS analisadas.
3.  **Valor de Portfólio:** Demonstra profundidade e competência em um dos três maiores e mais requisitados provedores de nuvem do mercado.

## Consequências

### Positivas
* **Paridade de Ambientes:** O uso de uma única plataforma garante consistência entre os ambientes de Homologação e Produção, reduzindo o risco de bugs específicos de ambiente, e um melhor controle técnico e financeiro.
* **Gestão Simplificada (a longo prazo):** Toda a configuração de infraestrutura, segredos e deploys fica centralizada no ecossistema GCP, com um único padrão de ferramentas e scripts.
* **Performance Consistente:** Ambos os ambientes se beneficiam do desempenho otimizado do Cloud Run.

### Negativas
* **Curva de Aprendizado Inicial:** Exige um esforço maior na configuração inicial do projeto no GCP (setup de faturamento, projetos, APIs, IAM) em comparação com plataformas PaaS.
* **Complexidade do Fluxo de Homologação:** A criação de ambientes de teste efêmeros (similares a PR Previews) é mais complexa de configurar no GCP, nos levando a adotar um ambiente de homologação persistente como abordagem inicial.