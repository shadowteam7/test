# Etapa 1: Construcción
FROM node:18 as build

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Construye la aplicación Angular SSR
RUN npm run build:ssr

# Etapa 2: Producción
FROM nginx:stable-alpine as production

# Copia los archivos de configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Elimina los archivos HTML por defecto de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos estáticos compilados desde la etapa de construcción
COPY --from=build /app/dist/browser /usr/share/nginx/html
COPY --from=build /app/dist/server /app/server

# Copia y establece los permisos del script de inicio
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expone el puerto de la aplicación
EXPOSE 80

# Comando para ejecutar Nginx y la aplicación SSR
CMD ["/app/start.sh"]
