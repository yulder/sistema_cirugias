FROM eclipse-temurin:11-jre

WORKDIR /fuseki

# Descargar y descomprimir Apache Jena Fuseki
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-4.8.0.zip \
    && unzip apache-jena-fuseki-4.8.0.zip \
    && mv apache-jena-fuseki-4.8.0/* /fuseki/ \
    && rm -rf apache-jena-fuseki-4.8.0 apache-jena-fuseki-4.8.0.zip \
    && apt-get remove -y wget unzip \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio para datos persistentes
RUN mkdir -p /fuseki/databases/programacioncirugia

# Copiar archivo de configuración
COPY config.ttl /fuseki/config.ttl

ENV FUSEKI_DATASET=proyectogestion
ENV ADMIN_PASSWORD=admin123

# Exponer el puerto
EXPOSE 3030

# Comando para iniciar Fuseki con la configuración
//CMD ["/fuseki/fuseki-server", "--config=/fuseki/config.ttl"]
CMD ["/jena-fuseki/fuseki-server", "--mem", "--update", "--localhost=false", "/programacioncirugia"]
