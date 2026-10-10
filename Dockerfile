FROM nginx:alpine

# Biblioteca vulnerável adicionada apenas para teste
ADD https://repo.maven.apache.org/maven2/org/apache/logging/log4j/log4j-core/2.14.1/log4j-core-2.14.1.jar /opt/teste-cve/log4j-core-2.14.1.jar

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
