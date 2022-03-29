# FROM openjdk:8-jre-alpine3.9
# LABEL maintainer="Shivakumar Ningappa <shivagowda@gmail.com>"

# Copy the already build jar to the image
# COPY target/jhttp-1.0-SNAPSHOT.jar /bin/

# Expose default port for external communication
# EXPOSE 8888

# Command to run the executable
# ENTRYPOINT [ "java" ,"-jar",  "/bin/jhttp-1.0-SNAPSHOT.jar" ]




FROM node:12-alpine
ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache

FROM node:12-alpine
ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/node_modules node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
