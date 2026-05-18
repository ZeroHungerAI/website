FROM golang:1.21-alpine AS build
RUN apk add --no-cache git gcc g++ musl-dev
RUN go install github.com/gohugoio/hugo@v0.121.2
WORKDIR /src
COPY ZeroHunger.ai ./ZeroHunger.ai
RUN cd ZeroHunger.ai && hugo --minify

FROM nginx:alpine
COPY --from=build /src/ZeroHunger.ai/public /usr/share/nginx/html
EXPOSE 80
