#Build Steps
FROM node:alpine3.10 as build-step

RUN mkdir /app
WORKDIR /app

COPY package.json /app
RUN npm install
COPY . /app

RUN npm run build

#Run Steps
FROM nginx:1.19.8-alpine  

RUN chgrp -R 0 /etc/nginx/ /var/cache/nginx /var/run /var/log/nginx  && \ 
  chmod -R g+rwX /etc/nginx/ /var/cache/nginx /var/run /var/log/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf

# comment user directive as master process is run as user in OpenShift random UID
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY --from=build-step /app/build /usr/share/nginx/html

EXPOSE 8080