FROM node:26-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app 

COPY ./package*.json ./

RUN npm ci --only=production

COPY ./index.js ./

COPY ./public/ ./public

USER appuser

EXPOSE 3000

CMD ["node", "index.js"]