# Ñeque — imagen para levantar la app web y el BFF en local.
# El codigo vive en el repositorio de la aplicacion; esta imagen lo clona en el build.
#   docker compose up --build
ARG NODE_VERSION=22-alpine
ARG APP_REPO=https://github.com/cosyfps/api-any-neque-mobile-app.git
ARG APP_REF=develop

# ---- fuente: clona el repositorio de la aplicacion ----
FROM node:${NODE_VERSION} AS source
ARG APP_REPO
ARG APP_REF
RUN apk add --no-cache git
WORKDIR /app
RUN git clone --depth 1 --branch ${APP_REF} ${APP_REPO} . \
 && HUSKY=0 npm ci

# ---- api: BFF Hono servido con Node en el puerto 3000 ----
FROM source AS api
ENV NODE_ENV=production PORT=3000
EXPOSE 3000
CMD ["npx", "tsx", "--tsconfig", "tsconfig.server.json", "server/dev.ts"]

# ---- build del front (Angular) ----
FROM source AS web-build
RUN npm run build:prod

# ---- web: Nginx sirve el front y reenvia /api al BFF ----
FROM nginx:1.27-alpine AS web
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=web-build /app/dist/neque/browser /usr/share/nginx/html
EXPOSE 80
