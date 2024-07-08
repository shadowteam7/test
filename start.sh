#!/bin/sh

# Iniciar la aplicación Angular SSR en segundo plano
node /app/server/main.js &

# Iniciar Nginx
nginx -g "daemon off;"
