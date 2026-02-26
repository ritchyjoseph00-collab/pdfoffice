FROM tomcat:10-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY dist/pdfoffice.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8086
ENV PORT=8086
CMD ["catalina.sh", "run"]