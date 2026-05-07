# -------------------------------------------------------
# Build Stage
# -------------------------------------------------------
FROM node:22 AS build

RUN apt-get update \
 && apt-get install -y \
      build-essential \
      gcc \
      g++ \
      autoconf \
      automake \
      make \
      libz-dev \
      libpng-dev \
      libvips-dev \
      git \
      bash \
 && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
ENV CI=true

WORKDIR /opt

# create strapi project non-interactive
RUN npx create-strapi-app@latest app \
    --quickstart \
    --no-run \
    --skip-cloud \
    --use-yarn

WORKDIR /opt/app

RUN yarn build


# -------------------------------------------------------
# Production Stage
# -------------------------------------------------------
FROM node:22

RUN apt-get update \
 && apt-get install -y libvips \
 && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production

WORKDIR /opt/app

COPY --from=build /opt/app ./

ENV PATH=/opt/app/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node

EXPOSE 1337

CMD ["yarn", "start"]
