# ADR-001: Escolha da Stack de Tecnologia Principal

* **Status:** Aceito
* **Data:** 2025-10-06

## Contexto

Para iniciar o projeto, era necessário definir a stack tecnológica principal para a construção da API. As restrições eram: a tecnologia deveria ser moderna, robusta, amplamente utilizada no mercado, possuir um ecossistema maduro e ser compatível com as camadas gratuitas de plataformas de nuvem. A preferência era por uma linguagem compilada e de alta performance E que fosse de domínio técnico do time.

A opção considerada foi um módulo Java único, construido com frameworks como Spring Boot ou Quarkus.

## Decisão

Adotaremos a seguinte stack de tecnologia para o MVP:

1.  **Linguagem: Java 21 (LTS)**. A escolha pela versão 21, em detrimento da 17, se baseia no equilíbrio entre uma versão atualizada, estável e com suporte prolongado (LTS), que aborda recursos modernos como Virtual Threads - ideais para aplicações I/O-bound como a nossa.

2.  **Framework: Spring Boot**. Embora Quarkus seja uma opção performática, Spring Boot foi escolhido por seu vasto ecossistema, imensa quantidade de documentação e recursos de aprendizado, e por se alinhar com o objetivo de aprofundar o conhecimento e habilidade técnica do time de desenvolvimento em uma tecnologia central no mercado.

3.  **Build Tool: Maven**. Escolhido por sua ubiquidade e integração simplificada com ferramentas de CI/CD como GitHub Actions e SonarCloud.

## Consequências

### Positivas
* A stack é extremamente madura e confiável, com uma comunidade gigante para suporte.
* Alinha-se com o objetivo de aprendizado e aprofundamento em tecnologias de alta demanda.
* A escolha do Java 21 nos prepara para otimizações de performance futuras.

### Negativas
* O Spring Boot tradicional tem um tempo de "cold start" e um consumo de memória maiores em comparação com alternativas. Este é um trade-off conhecido e aceito, que será gerenciado através da escolha da plataforma de hospedagem e da comunicação da experiência do usuário (ex: mensagens de "aguarde").
* A otimização para performance de startup (via GraalVM Native Image) é mais complexa no Spring Boot e será considerada apenas como uma melhoria futura.