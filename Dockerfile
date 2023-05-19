# Usar una imagen base con JDK 11
FROM adoptopenjdk:11-jdk-hotspot as builder

# Directorio de trabajo
WORKDIR application

# Copiar el fichero .jar al contenedor
COPY build/libs/*.jar application.jar

# Extraer el .jar
RUN java -Djarmode=layertools -jar application.jar extract

# Usar una imagen base con JRE 11
FROM adoptopenjdk:11-jre-hotspot

# Copiar las dependencias
COPY --from=builder application/dependencies/ ./

# Copiar los recursos estáticos
COPY --from=builder application/spring-boot-loader/ ./

# Copiar las clases de la aplicación
COPY --from=builder application/snapshot-dependencies/ ./

# Copiar las clases de la aplicación
COPY --from=builder application/application/ ./

# Ejecutar la aplicación
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
