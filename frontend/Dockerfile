FROM node:14.17.3 as build-stage
WORKDIR /app
COPY . .
RUN npm install && npm install -g http-server && npm run build

FROM nginx:latest
COPY --from=build-stage /app/dist/frontend/ /usr/share/nginx/html
EXPOSE 80
