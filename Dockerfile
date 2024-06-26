# Etapa 1: Construir la aplicación Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Verificación de los archivos construidos
RUN ls -l /app/dist/my-app

# Etapa 2: Configurar Nginx para servir la aplicación
FROM nginx:latest
COPY --from=build /app/dist/my-app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Verificación de los archivos copiados
RUN ls -l /usr/share/nginx/html
RUN ls -l /etc/nginx/conf.d

# Exponer el puerto en el que Nginx servirá la aplicación
EXPOSE 80
