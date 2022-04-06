FROM node:14.17.3 as build-stage
WORKDIR /app
COPY . .
RUN npm install && npm install -g http-server && npm run build

FROM nginxproxy/nginx-proxy
COPY --from=build-stage /app/dist/frontend/ /usr/share/nginx/html
COPY --from=build-stage /app/nginx.tmpl /app/nginx.tmpl
EXPOSE 80
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
