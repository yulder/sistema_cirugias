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
RUN mkdir -p /fuseki/databases/PROYECTOGESTION

# Configurar CORS
RUN mkdir -p /fuseki/webapp/WEB-INF
COPY web.xml /fuseki/webapp/WEB-INF/web.xml

# Copiar archivo de configuración
COPY config.ttl /fuseki/config.ttl

# Crear un dataset de ejemplo si no existe
RUN echo "@prefix :      <http://www.semanticweb.org/usuariotsc/ontologies/2025/4/PROYECTO/> . \
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> . \
@prefix owl:   <http://www.w3.org/2002/07/owl#> . \
:Paciente rdf:type owl:Class . \
:Cirugia rdf:type owl:Class . \
:SalaCirugia rdf:type owl:Class ." > /fuseki/databases/PROYECTOGESTION/initial-data.ttl

# Exponer el puerto
EXPOSE 3030

# Comando para iniciar Fuseki con la configuración
CMD ["/fuseki/fuseki-server", "--config=/fuseki/config.ttl"]
