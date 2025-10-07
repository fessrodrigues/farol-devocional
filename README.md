# Farol Devocional API

Este projeto é uma API que disponibiliza devocionais cristãos via chat, com o objetivo de organizar ideias e abordar temas da fé para apoiar o usuário em seus estudos e reflexões. Embora seja um projeto piloto com um forte teor espiritual, ele está sendo desenvolvido com a seriedade e a estrutura de um projeto pronto para produção.

## Propósito

O "Farol Devocional" visa apoiar cristãos em conteúdo de qualidade para entendimento e estudos dos textos bíblicos, de modo a extrair ao máximo o contexto original e paralelos práticos com a realidade atual. É um projeto sem fins comerciais, comprometido com o cristianismo e a fé no Evangelho de Cristo. O conteúdo gerado por este software destina-se **exclusivamente** à fé cristã como apoio em devocionais, não devendo ser utilizado como substituto dos estudos pessoais, orações e, principalmente, da direção que o Espírito Santo confere pela fé. Não deve ser utilizado, em nenhuma hipótese, para fins comerciais, jurídicos, médicos, psicológicos ou como conselho oficial de igrejas/denominações.

## Tecnologias Utilizadas

Este projeto utiliza as seguintes tecnologias:

*   **Java:** Linguagem de programação principal.
*   **Spring Boot:** Framework web para construção da API.
*   **Maven:** Para gerenciamento de dependências.
*   **Docker:** Para conteinerização da aplicação.

## Estrutura do Projeto

A estrutura do projeto é organizada da seguinte forma:

```
├── .mvn/
│   └── wrapper/
│       ├── maven-wrapper.jar
│       └── maven-wrapper.properties
├── api-collections/
├── docs/
├── infra/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── farol/
│   │   │           └── devocional/
│   │   │               ├── FarolDevocionalApplication.java
│   │   │               ├── config/
│   │   │               ├── service/
│   │   │               └── model/
│   │   └── resources/
│   │       ├── application.properties
│   │       └── logback-spring.xml
│   └── test/
├── mvnw
└── mvnw.cmd