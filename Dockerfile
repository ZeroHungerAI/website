# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM hugomods/hugo:exts-0.152.2 AS builder

ARG RELEASE_TAG=""
ARG BASE_URL=""

WORKDIR /src
COPY ZeroHunger.ai ./ZeroHunger.ai
COPY resources ./resources
RUN cd ZeroHunger.ai && HUGO_ENABLEGITINFO=false hugo --minify --gc ${BASE_URL:+--baseURL "$BASE_URL"}

# ── Stage 2: Serve ────────────────────────────────────────────────────────────
FROM nginx:1.27-alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /src/ZeroHunger.ai/public /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1
