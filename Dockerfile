# -----
FROM node:14.4-alpine AS build

RUN apk update
RUN apk add --no-cache bash file postgresql mosquitto nano 
#ENV PYTHONUNBUFFERED=1
#RUN apk add --no-cache python3 && \
#    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi 


WORKDIR /usr/src/kdx
COPY . .
RUN npm install
RUN npm install -g emanator@latest
RUN emanator --local-binaries --http
#RUN mv /usr/src/dagviz/k-explorer /usr/src/k-explorer
#RUN cd /usr/src/k-explorer && npm install && npm link
#RUN npm link k-explorer
#RUN mv /usr/src/dagviz/k-explorer /usr/src/dagviz/k-explorer
#RUN cd /usr/src/dagviz/k-explorer && npm install && npm link
#RUN npm link k-explorer

RUN addgroup -S kdx && adduser -S kdx -G kdx
RUN mkdir -p /run/postgresql
RUN chown kdx:kdx /run/postgresql

# Tell docker that all future commands should run as the appuser user
USER kdx

EXPOSE 16210 16211 16310 16311 11224 18787 18792

ENTRYPOINT ["node","kdx.js","--init"]