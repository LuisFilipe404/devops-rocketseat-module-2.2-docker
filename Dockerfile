FROM node:20-alpine AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn

COPY . .

RUN yarn run build

RUN yarn --production=false && yarn cache clean

FROM node:20-alpine AS runner

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./

EXPOSE 3000

CMD ["node", "dist/main.js"]