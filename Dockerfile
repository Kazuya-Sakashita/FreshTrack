# Apple Silicon (M1チップ)で動作するARMベースのイメージを使用
FROM ruby:3.0.2

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-mysql-client curl

# Node.jsとYarnのインストール
# NodeSourceのリポジトリを追加して、最新のLTS版Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Yarnの公式APTリポジトリを追加してインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

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
