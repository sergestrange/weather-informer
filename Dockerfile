# syntax = docker/dockerfile:1

# Production Dockerfile (Rails + Vite). Build with:
#   docker build -t my-app .
#   docker run -d -p 3002:3002 --name my-app -e RAILS_MASTER_KEY=<...> my-app

ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

# --- runtime deps ---
RUN set -eux; \
  echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries; \
  apt-get update -qq; \
  apt-get install -y --no-install-recommends \
    curl libjemalloc2 libvips postgresql-client \
  || { sleep 5; apt-get update -qq; apt-get install -y --no-install-recommends \
    curl libjemalloc2 libvips postgresql-client --fix-missing; }; \
  rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# Throw-away build stage to reduce size of final image
FROM base AS build

# build deps for Ruby and Node (vite)
RUN set -eux; \
  echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries; \
  apt-get update -qq; \
  apt-get install -y --no-install-recommends \
    build-essential git libpq-dev pkg-config nodejs npm \
  || { sleep 5; apt-get update -qq; apt-get install -y --no-install-recommends \
    build-essential git libpq-dev pkg-config nodejs npm --fix-missing; }; \
  rm -rf /var/lib/apt/lists/*

# JS deps
COPY package.json package-lock.json* pnpm-lock.yaml* ./
RUN set -eux; \
  if [ -f pnpm-lock.yaml ]; then \
    npm install -g pnpm@9 && \
    pnpm install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then \
    npm ci; \
  else \
    npm install; \
  fi

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# precompile assets (vite:build_all теперь видит node_modules)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final stage for app image
FROM base

COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3002
CMD ["./bin/rails", "server"]
