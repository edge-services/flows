##
##
## This will build SmartThings Edge NodeRed Flows container image
## Author: Gurvinder Singh (gurvsin3@in.ibm.com)
##
## DOCKER_BUILDKIT=1 docker build -t sinny777/edge-flows:latest .
## docker run --rm -it -p 1880:1880 --name  edge-flows --env-file .env sinny777/edge-flows:latest
##

FROM nodered/node-red

RUN export CPPFLAGS=-I/usr/local/opt/openssl/include && \
    export LDFLAGS=-L/usr/local/opt/openssl/lib

# RUN export OPENSSL_ROOT_DIR=/usr/local/opt/openssl && \
#     export LDFLAGS="-L$OPENSSL_ROOT_DIR/lib -L/usr/local/opt/gsas/lib" && \
#     export CPPFLAGS="-I$OPENSSL_ROOT_DIR/include" && \
#     export OPENSSL_INCLUDE_DIR=$OPENSSL_ROOT_DIR/include

COPY package.json .
COPY package-lock.json .
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production \
    && npm uninstall node-red-node-gpio

# Copy _your_ Node-RED project files into place
# NOTE: This will only work if you DO NOT later mount /data as an external volume.
#       If you need to use an external volume for persistence then
#       copy your settings and flows files to that volume instead.
COPY flows.json .
COPY settings.js .
ADD config /data
ADD certs ./certs

# Env variables
ENV FLOWS=flows.json \
    TZ=Asia/Kolkata

ENV HOST=0.0.0.0 PORT=1880
# Expose the listening port of node-red
EXPOSE 1880

ENTRYPOINT ["npm", "start", "--cache", "/data/.npm", "--", "--userDir", "/data"]