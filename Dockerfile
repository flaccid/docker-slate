FROM ruby:2.3.0-alpine

MAINTAINER Chris Fordham <chris@fordham-nagy.id.au>

COPY slate /opt/slate

RUN apk add --update \
  libxml2-dev libxslt-dev \
  libffi-dev \
  make \
  build-base \
  alpine-sdk \
  nodejs

WORKDIR /opt/slate

RUN bundle config build.nokogiri --use-system-libraries && \
  bundle install && \
  bundle exec gem list

# remove build deps
RUN apk --purge del \
  libxml2-dev libxslt-dev \
  libffi-dev \
  make \
  build-base \
  alpine-sdk

# clean apk cache
RUN rm -rf /var/cache/apk/*

EXPOSE 4567

CMD ["bundle", "exec", "middleman", "server"]
