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

# docker build -t trajectory-frontend-client .
# docker build -t trajectory-frontend-admin .
