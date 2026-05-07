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
      bash

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt

COPY package.json yarn.lock ./

# Ensure node-gyp works correctly
RUN yarn global add node-gyp

# Install dependencies
RUN yarn config set network-timeout 600000 -g && yarn install --frozen-lockfile

ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .

RUN yarn build

# -------------------------------------------------------
# Production Stage
# -------------------------------------------------------
FROM node:22

# Install runtime dependencies only
RUN apt-get update \
 && apt-get install -y libvips \
 && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app

COPY --from=build /opt/node_modules ./node_modules
COPY --from=build /opt/app ./

ENV PATH=/opt/node_modules/.bin:$PATH

# Set permissions
RUN chown -R node:node /opt/app
USER node

EXPOSE 1337

CMD ["yarn", "start"]
