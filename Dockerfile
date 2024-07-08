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

# Compila server.ts a server.js
RUN npx tsc server.ts --outDir dist

# Etapa 2: Producción
FROM node:18 as production

# Establece el directorio de trabajo
WORKDIR /app

# Copia package.json y package-lock.json para instalar las dependencias de producción
COPY --from=build /app/package*.json ./

# Instala las dependencias de producción
RUN npm install --only=production

# Copia los archivos compilados desde la etapa de construcción
COPY --from=build /app/dist ./dist
COPY --from=build /app/tsconfig.server.json ./tsconfig.server.json
COPY --from=build /app/src/environments/environment.prod.ts ./src/environments/environment.prod.ts

# Copia el archivo compilado server.js
COPY --from=build /app/dist/server.js ./server.js

# Expone el puerto de la aplicación
EXPOSE 4000

# Comando para ejecutar la aplicación
CMD ["node", "server.js"]
