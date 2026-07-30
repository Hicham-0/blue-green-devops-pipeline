FROM public.ecr.aws/docker/library/node:24-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

RUN npm install -g npm@latest

COPY ./package*.json ./
RUN npm ci --omit=dev

COPY ./index.js ./
COPY ./public/ ./public

# npm n'est plus nécessaire à l'exécution (CMD utilise node directement) —
# on le retire pour éliminer sa propre chaîne de dépendances vendorisées (dont brace-expansion vulnérable)
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

USER appuser

EXPOSE 3000

CMD ["node", "index.js"]