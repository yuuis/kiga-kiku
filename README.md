# Kiku

prototype of *kiga-kiku flamework* ver.1 

## how to build
```sh
  $ docker-compose build
  $ docker-compose run kiku bundle exec hanami db prepare
  $ docker-compose run kiku bundle exec ruby db/seeds/seed.rb
  $ docker-compose up -d
  $ ssh -R kigakiku:80:localhost:2300 serveo.net
```

## how to access mysql_data
```sh
  $ docker run -v kiku_mysql_data:/srv -it ubuntu bash
```

## lint
```sh
  docker-compose run kiku bundle exec rubocop -a
```

## api
  * GET `/shops`
    * query params
      * `user_id`
      * `words` (seperated of `,`)
  * GET `/went_shops/`
    * query params
      * `user_id`
  * GET `/guess_like/`
    * query params
      * `user_id`
  * GET `/guess_dislike/`
    * query params
        * `user_id`
