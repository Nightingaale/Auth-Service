FROM eclipse-temurin:17-jre AS builder
WORKDIR /extracted
COPY build/libs/*.jar auth-service.jar
RUN java -Djarmode=layertools -jar auth-service.jar extract

FROM eclipse-temurin:17-jdk
WORKDIR /application

COPY --from=builder /extracted/dependencies/ ./
COPY --from=builder /extracted/spring-boot-loader/ ./
COPY --from=builder /extracted/snapshot-dependencies/ ./
COPY --from=builder /extracted/application/ ./

EXPOSE 8090
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]