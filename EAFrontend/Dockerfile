FROM cirrusci/flutter:stable as build-step
FROM nginx:1.20.2-alpine
WORKDIR /app
#COPY . .
#RUN flutter build web

COPY  build/web /usr/share/nginx/html
