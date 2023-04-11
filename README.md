
## Install

### Clone the repository

```shell
git clone git@github.com:arslanahmad05/news-articles-api.git # ssh
git clone https://github.com/arslanahmad05/news-articles-api.git # https
cd news-articles-api
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.0.0`

If not, install the right ruby version using [rvm](https://rvm.io/) (it could take a while):

```shell
rvm install 3.0.0
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) :

```shell
bundle install
```

### Set environment variables

Using [dotenv](https://github.com/bkeepers/dotenv):

See [.env.sample](https://github.com/arslanahmad05/news-articles-api/blob/master/.env.sample) and contact the developer: [arslanahmad0075@gmail.com](mailto:arslanahmad0075@gmail.com) (sensitive data).

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

## Serve

```shell
rails s
```

## API Documentation

See [swagger.yaml](https://github.com/arslanahmad05/news-articles-api/blob/master/swagger/v1/swagger.yaml) for API Documentation
