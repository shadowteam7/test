# Etapa 1: Construcción de la aplicación Angular
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build:ssr

# Etapa 2: Configuración del servidor
FROM node:18

WORKDIR /app

COPY --from=build /app/dist /app/dist
COPY --from=build /app/package*.json ./

RUN npm install --only=prod

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["node", "dist/my-app/server/main.js"]

EXPOSE 4000
