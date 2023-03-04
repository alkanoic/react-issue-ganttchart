ARG APP_HOME=/home/node/app

# build stage
FROM node:16 as build
WORKDIR ${APP_HOME}

COPY package.json ${APP_HOME}
RUN yarn install
# COPY . ${APP_HOME}
COPY public/ ${APP_HOME}/public
COPY src/ ${APP_HOME}/src
COPY demo-rig.gif ${APP_HOME}
COPY LICENSE ${APP_HOME}
RUN chmod +x node_modules/.bin/react-scripts
RUN yarn build

# deploy stage
FROM nginx:alpine
COPY --from=build ${APP_HOME}/build /var/www
COPY ./nginx /etc/nginx/conf.d/

WORKDIR /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
