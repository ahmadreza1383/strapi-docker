# Creating multi-stage build for production
FROM ghcr.io/ahmadreza1383/strapi-base-dev AS build
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/app
COPY . .
RUN npm run build

# # Creating final production image
FROM node:22-alpine
## You can adding your custom repository
# RUN ALPINE_VERSION=$(cat /etc/alpine-release | cut -d'.' -f1-2) && \
# echo "https://linux-mirror.liara.ir/repository/alpine/v${ALPINE_VERSION}/main" > /etc/apk/repositories && \
# echo "https://linux-mirror.liara.ir/repository/alpine/v${ALPINE_VERSION}/community" >> /etc/apk/repositories
RUN apk add --no-cache vips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/app
COPY --from=build --chown=node:node /opt/node_modules ./node_modules
COPY --from=build --chown=node:node --exclude=node_modules /opt/app ./
ENV PATH=/opt/app/node_modules/.bin:$PATH

USER node
EXPOSE 1337
CMD ["npm", "run", "start"]
