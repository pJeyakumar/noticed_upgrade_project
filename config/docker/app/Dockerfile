# <https://medium.com/firehydrant-io/developing-a-ruby-on-rails-app-with-docker-compose-d75b20334634>
FROM ruby:3.3.1-alpine3.18
WORKDIR /app

# Additional packages needed for compiling gems
RUN apk update \
    && apk add --no-cache \
    bash \
    build-base \
    coreutils \
    git \
    postgresql-client \ 
    libpq-dev \
    libc6-compat

# Expose Puma port
EXPOSE 3000
EXPOSE 1234
EXPOSE 26162