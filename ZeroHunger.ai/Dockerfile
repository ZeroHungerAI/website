# syntax=docker/dockerfile:1

# build environment
FROM klakegg/hugo:0.101.0-onbuild AS hugo


# WORKDIR /src
# COPY . .

# RUN git submodule update --init
# RUN hugo
# production environment
FROM nginx:stable-alpine
COPY --from=hugo /target /usr/share/nginx/html
#COPY --from=builder /src/public /usr/share/nginx/html
#COPY public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]