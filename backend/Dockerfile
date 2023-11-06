FROM node:19.9.0

WORKDIR /app
RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm

COPY package*.json ./
RUN pnpm i

COPY . .

EXPOSE 3000
CMD ["pnpm", "start:dev"]