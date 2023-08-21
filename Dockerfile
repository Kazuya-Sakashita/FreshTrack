# Apple Silicon (M1チップ)で動作するARMベースのイメージを使用
FROM ruby:3.0.2

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client

# 作業ディレクトリを設定
WORKDIR /myapp

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerのインストール
RUN gem install bundler

# Gemのインストール
RUN bundle install

# entrypoint.shをコピー
COPY entrypoint.sh /usr/bin/

# 実行権限を設定
RUN chmod +x /usr/bin/entrypoint.sh

# エントリーポイントを設定
ENTRYPOINT ["entrypoint.sh"]

# すべてのファイルをコピー
COPY . /myapp
