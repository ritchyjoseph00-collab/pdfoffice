FROM tomcat:10-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY dist/pdfoffice.war /usr/local/tomcat/webapps/ROOT.war

# Script qui remplace le port de Tomcat par celui de Railway
RUN sed -i 's/port="8080"/port="8086"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8086

CMD ["catalina.sh", "run"]