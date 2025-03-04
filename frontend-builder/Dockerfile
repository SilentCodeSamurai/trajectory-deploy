# Nginx server
FROM nginx:alpine
WORKDIR /usr/share/nginx/

# Remove default nginx index page
RUN rm -rf html
RUN mkdir html
WORKDIR /
# Copy local nginx config
COPY ./nginx.conf /etc/nginx
# Copy compiled app statics
COPY ./build /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]

# docker build -t trajectory-frontend-client:31 .
# docker build -t trajectory-frontend-admin:31 .

# docker tag trajectory-frontend-client localhost:5000/trajectory-frontend-client:latest
# docker tag trajectory-frontend-admin:2 localhost:5000/trajectory-frontend-admin:2
# docker push localhost:5000/trajectory-frontend-client:latest

# curl http://localhost:5000/v2/_catalog

# curl http://localhost:5000/v2/trajectory-frontend-client/tags/list
# curl http://localhost:5000/v2/trajectory-frontend-admin/tags/list