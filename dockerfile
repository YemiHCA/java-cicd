# Stage 1: Build the Java application
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy application source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests


# Stage 2: Run the Java application
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the generated JAR file
COPY --from=build /app/target/*.jar app.jar

# Application port
EXPOSE 8080

# Start the Java application
ENTRYPOINT ["java", "-jar", "app.jar"]