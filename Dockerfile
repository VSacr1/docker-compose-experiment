FROM node:10 as client-build
WORKDIR /build
COPY client .
RUN npm install 
RUN npm run build
FROM maven as server-build
WORKDIR /build
COPY server . 
COPY --from=client-build /build/build src/main/resources/static
RUN mvn clean package
FROM java:8 
WORKDIR /opt/app
COPY --from=server-build /build/target/app-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["/usr/bin/java", "-jar", "app.jar"]
