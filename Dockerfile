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
FROM node:18 as production

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos compilados desde la etapa de construcción
COPY --from=build /app/dist ./dist
COPY --from=build /app/server.ts ./server.ts
COPY --from=build /app/tsconfig.server.json ./tsconfig.server.json
COPY --from=build /app/src/environments/environment.prod.ts ./src/environments/environment.prod.ts

# Instala las dependencias de producción
RUN npm install --only=production

# Expone el puerto de la aplicación
EXPOSE 4000

# Comando para ejecutar la aplicación
CMD ["node", "server.js"]
