# Estágio 1: Build da Aplicação com Maven
# Usamos uma imagem oficial do Maven com JDK 21 para compilar nosso projeto.
FROM maven:3.9-eclipse-temurin-21 AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo pom.xml primeiro para aproveitar o cache de dependências do Docker
COPY pom.xml .

# Baixa as dependências do projeto
RUN mvn dependency:go-offline

# Copia o restante do código-fonte
COPY src ./src

# Compila o projeto e gera o arquivo .jar, pulando os testes que já rodaram no CI
RUN mvn clean install -DskipTests


# Estágio 2: Imagem Final de Execução
# Usamos uma imagem JRE (Java Runtime Environment) mínima, para uma imagem final leve e segura.
FROM eclipse-temurin:21-jre-jammy

# Define o diretório de trabalho
WORKDIR /app

# Copia o .jar gerado no estágio anterior para a imagem final
COPY --from=builder /app/target/*.jar app.jar

# Expõe a porta 8080, que é a padrão do Spring Boot
EXPOSE 8080

# Comando para executar a aplicação quando o contêiner iniciar
ENTRYPOINT ["java", "-jar", "app.jar"]