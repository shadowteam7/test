# FROM node:14-alpine as build-step
# #FROM node:14 as build-step
#     RUN mkdir -p /app
#     WORKDIR /app
#     COPY package.json /app
#     RUN npm install
#     RUN npm install -g npm@7.20.5
#     COPY . /app
#     RUN npm run build --prod

# FROM nginx:latest
# COPY --from=build-step /app/dist/angularapp /usr/share/nginx/html
# Etapa 1: Construcción
FROM node:18 AS build

# Crear directorio de la aplicación
WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el código fuente y construir la aplicación
COPY . .
RUN npm run build --configuration production

# Etapa 2: Servir la aplicación
FROM nginx:alpine

# Copiar los archivos construidos desde la etapa de construcción
COPY --from=build /app/dist/tu-app-angular /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Exponer el puerto en el que Nginx servirá la aplicación
EXPOSE 80

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
