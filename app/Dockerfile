FROM node:24-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Mise à jour de npm pour corriger les vulnérabilités connues de versions embarquées
RUN npm install -g npm@latest

COPY ./package*.json ./

RUN npm ci --only=production

COPY ./index.js ./

COPY ./public/ ./public

USER appuser

EXPOSE 3000

CMD ["node", "index.js"]