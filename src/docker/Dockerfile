FROM openjdk:8
WORKDIR /minecraft
ARG SERVER_DOWNLOAD_LINK
RUN wget ${SERVER_DOWNLOAD_LINK}
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
