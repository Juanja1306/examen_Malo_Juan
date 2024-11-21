#debian
FROM debian:bullseye-slim

#angular 
FROM node:18.16.1-alpine AS build-frontend

RUN npm install -g @angular/cli

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ ./

RUN npm run build --prod

RUN apk add --no-cache apache2

RUN mkdir -p /var/www/html

RUN cp -r /app/frontend/dist/frontend/* /var/www/html/

RUN ls -l /var/www/html

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]

#Node
FROM node:18.16.1-alpine
WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install

COPY backend/ ./

COPY --from=build-frontend /app/frontend/dist/frontend/browser ./public

EXPOSE 80

CMD ["node", "index.js"]


