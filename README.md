# Kiku

気が利くフレームワークのプロトタイプ1号

## how to build
```sh
  $ docker-compose build
  $ docker-compose run kiku bundle exec hanami db prepare
  
  $ docker-compose run kiku bundle exec ruby db/seeds/shop_genre.rb
  $ docker-compose run kiku bundle exec ruby db/seeds/small_area.rb
  $ docker-compose run kiku bundle exec ruby db/seeds/user.rb

  $ docker-compose up
```
