# syntax=docker/dockerfile:1
# check=error=true

# Dockerfile for production deployment (Fly.io ready)

ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /app

# Install OS packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    sqlite3 \
    nodejs \
    yarn \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Throw-away build stage to reduce final image size
FROM base AS build

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/"*/cache "${BUNDLE_PATH}/ruby/"*/bundler/gems/*/.git

COPY . .

# Precompile bootsnap and assets
RUN bundle exec bootsnap precompile --gemfile
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final production image
FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Create a non-root user
RUN groupadd --system rails && \
    useradd rails --gid rails --create-home --shell /bin/bash && \
    chown -R rails:rails /app

USER rails

# Copy entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

# Fly expects apps to listen on port 8080
EXPOSE 8080

# Start Rails server using Puma (used by default in production)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
