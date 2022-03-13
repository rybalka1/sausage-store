FROM node:14.17.3
WORKDIR /usr/src/app
COPY . .
RUN npm install \
    && npm install -g http-server \
    && npm run build
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]
