
FROM ruby:2.3.8-slim

RUN set -ex \
	\
  curl -sL https://deb.nodesource.com/setup_6.x | bash - \
	&& requiredPackages=' \
    net-tools \
    netcat \
    vim-tiny \
    nodejs \
    imagemagick \
    file \
    build-essential \
    libssl-dev libffi-dev \
    default-libmysqlclient-dev \
    shared-mime-info \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $requiredPackages

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN gem install bundler

RUN bundle install --without development test

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
