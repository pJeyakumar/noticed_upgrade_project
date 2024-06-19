# <https://medium.com/firehydrant-io/developing-a-ruby-on-rails-app-with-docker-compose-d75b20334634>
FROM ruby:3.3.2-alpine
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
    libc6-compat \ 
    nodejs

# Expose Puma port
EXPOSE 3000
EXPOSE 1234
EXPOSE 26162