FROM node:23.10 AS tabu-app
WORKDIR /app
COPY ./tabu-db-api/package*.json ./
RUN npm install
COPY ./tabu-app/ /app
EXPOSE 5173
CMD ["npm", "run", "dev"]

FROM node:23.10 AS tabu-db-api
WORKDIR /app
COPY ./tabu-db-api/package*.json ./
RUN npm install -g nodemon
RUN npm install
COPY ./tabu-db-api/ .
EXPOSE 3001
CMD ["npm", "start"]