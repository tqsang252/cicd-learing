# get the base node image
FROM node:16.13.1-alpine as builder

# set the working dir for container
WORKDIR /frontend

# copy the json file first
COPY ./package.json /frontend

# install npm dependencies
RUN npm install

# copy other project files
COPY . .

# build the folder


ARG ENV
ENV ENV $ENV

RUN npm run build-${ENV}

# Handle Nginx
FROM nginx
ARG ENV
ENV ENV $ENV
RUN echo "Environment: ${ENV}"
COPY ./docker/nginx-${ENV}/uhouse.crt /etc/nginx/
COPY ./docker/nginx-${ENV}/uhouse.key /etc/nginx
COPY --from=builder /frontend/dist/docker-angular /usr/share/nginx/html
COPY ./docker/nginx-${ENV}/default.conf /etc/nginx/conf.d/default.conf