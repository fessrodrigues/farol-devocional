# ADR-004: Plataforma de Hospedagem e Estratégia de Containerização

* **Status:** Em análise
* **Data:** 2025-10-07

## Contexto

AA seleção da plataforma de nuvem é uma decisão fundamental que impacta custo, performance, complexidade e o fluxo de trabalho de CI/CD. Diversas opções foram consideradas, incluindo uma arquitetura 100% no Render, uma abordagem híbrida Render+Azure e uma abordagem híbrida Render+GCP. Cada opção apresentava trade-offs significativos. A principal restrição é a necessidade de operar em uma camada gratuita robusta, com suporte a contêineres Docker e ambientes separados para Produção e Homologação.

Os Limites Atuais do "Always Free" do Cloud Run são:

    Requisições: 2 milhões/mês
    Memória: 360.000 GiB-segundos/mês
    CPU: 180.000 vCPU-segundos/mês

Estimativas:

    Requisições: ~90.000 req/mês (~3.000 req/dia) - menos de 5% da cota.

    CPU e Memória (A Análise Crítica):
        Estimativa de pico em 10 req/min.

        Uma requisição para a IA pode levar até 15 segundos. Se a CPU ficasse alocada durante todo esse tempo, nosso consumo seria 90.000 requisições * 15 segundos = 1.350.000 vCPU-segundos. Isso estouraria a cota.

        A Nuance Técnica Crucial: O Google Cloud Run tem uma configuração de alocação de CPU. Por padrão, a CPU só é alocada enquanto o seu código está ativamente processando dados. Durante a maior parte desses 15 segundos, nossa aplicação estará apenas esperando a resposta da API do Gemini (uma operação de I/O). Durante o I/O, o Cloud Run não aloca (e não cobra pela) CPU.

        Estimativa Realista de CPU: O processamento real do nosso código (receber a requisição, montar o prompt, tratar a resposta) levará talvez 2 segundo por requisição. Com isso, nosso consumo seria de 90.000 requisições * 2 segundo = 180.000 vCPU-segundos. Estaremos no limite porém atendendo satisfatoriamente.

## Decisão

Adotaremos a **containerização da aplicação com Docker** para possibilitar melhor portabilidade. O projeto será hospedado inteiramente no **Google Cloud Platform (GCP)**, utilizando o **Google Cloud Run** para todos os ambientes (Produção e Homologação).

A decisão de unificar a plataforma foi tomada priorizando o princípio de **Paridade de Ambientes (Environment Parity)**, um pilar de DevOps que garante a máxima consistência entre o que é testado e o que é implantado em produção. Embora a curva de aprendizado inicial do GCP seja maior que a de plataformas PaaS mais simples, os benefícios a longo prazo de uma infraestrutura homogênea, performática e escalável superam a conveniência inicial.

O Google Cloud Run foi escolhido como plataforma única por:
1.  **Modelo Serverless:** Sua arquitetura "scale-to-zero" e camada gratuita generosa garantem a viabilidade do custo zero.
2.  **Performance:** Oferece um tempo de "cold start" para contêineres Java superior às alternativas de PaaS analisadas.
3.  **Valor de Portfólio:** Demonstra profundidade e competência em um dos três maiores e mais requisitados provedores de nuvem do mercado.

## Consequências

### Positivas
* **Paridade de Ambientes:** Garante máxima consistência entre os ambientes de Homologação e Produção, reduzindo o risco de bugs específicos de ambiente.
* **Gestão Simplificada (a longo prazo):** Toda a configuração de infraestrutura, segredos e deploys fica centralizada no ecossistema GCP, com um único padrão de ferramentas e scripts.
* **Performance Consistente:** Ambos os ambientes se beneficiam do desempenho otimizado do Cloud Run.

### Negativas
* **Curva de Aprendizado Inicial:** Exige um esforço maior na configuração inicial do projeto no GCP (setup de faturamento, projetos, APIs, IAM) em comparação com plataformas PaaS.
* **Complexidade do Fluxo de Homologação:** A criação de ambientes de teste efêmeros (similares a PR Previews) é mais complexa de configurar no GCP, nos levando a adotar um ambiente de homologação persistente como abordagem inicial.