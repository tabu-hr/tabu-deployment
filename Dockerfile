# -------------------------------------------
# Base stage (shared for both dev and prod)
# -------------------------------------------
FROM node:23.10 AS base
WORKDIR /app
COPY ./tabu-app/package*.json ./
RUN npm install
COPY ./tabu-app/ .

# -------------------------------------------
# Development stage
# -------------------------------------------
FROM base AS development
EXPOSE 5173
CMD ["npm", "run", "dev"]

# -------------------------------------------
# Production stage
# -------------------------------------------
FROM base AS production
RUN npm run build

# -------------------------------------------
# Backend (tabu-db-api)
# -------------------------------------------
FROM node:23.10 AS tabu-db-api
WORKDIR /app
COPY ./tabu-db-api/package*.json ./
RUN npm install -g nodemon
RUN npm install
COPY ./tabu-db-api/ .
EXPOSE 3001
CMD ["npm", "start"]

# -------------------------------------------
# Production stage - Nginx
# -------------------------------------------
FROM nginx:alpine AS production-app
COPY --from=production /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]