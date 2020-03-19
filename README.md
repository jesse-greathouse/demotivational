Demotivational
====

A simple example application which uses the greathouse-openresty boilerplate.

# How to Install
These instructions assume that you've already created a useable database for your application, along with having the required credentials. If you do not need a database, you can ignore the database credentials or set them as placeholders for later. If you need help on creating a database, you can [learn how: here](https://www.postgresql.org/docs/10/tutorial-install.html).

* Download the git repository
    * `git clone https://github.com/jesse-greathouse/demotivational`
* Change to the demotivational directory
    * `cd demotivational`

## Docker Installation
* The easiest way to run the application  is with Docker. You will need to install docker on your host. Check the [Official Docker Site](https://docs.docker.com/engine/installation/) on how to install Docker on your host.
* Run the configuration script
    * `bin/configure-docker.sh`
* Run the "run" script
    * `bin/run-docker.sh`
* check [http://localhost:3000/](http://localhost:3000/)
    * You may have changed the designated port during configuration. If that's the case, use the port you specified.


# Docker Management Instructions
## Building the App
    docker build -t jessegreathouse/demotivational .

## Running the APP
    docker run -d -p 3000:3000 \
        -e ENV=prod \
        -e DEBUG=false \
        -e FORCE_SSL=false \
        -e DIR="/app" \
        -e BIN="/app/bin" \
        -e ETC="/app/etc" \
        -e OPT="/app/opt" \
        -e SRC="/app/src" \
        -e TMP="/app/tmp" \
        -e VAR="/app/var" \
        -e WEB="/app/web" \
        -e CACHE_DIR="/app/var/cache" \
        -e LOG_DIR="/app/var/logs" \
        -e REDIS_HOST=redis \
        -e DB_NAME="db_name" \
        -e DB_USER="db_user" \
        -e DB_PASSWORD="db_password" \
        -e DB_HOST="192.168.0.1" \
        -e DB_PORT=3306 \
        -v $(pwd)/error.log:/app/error.log \
        -v $(pwd)/supervisord.log:/app/supervisord.log \
        -v $(pwd)/etc/nginx/nginx.conf:/app/etc/nginx/nginx.conf \
        --restart no \
        --name my-site \
        jessegreathouse/demoticational

* check [http://localhost:3000/](http://localhost:3000/)

# Running Tests
    docker exec -ti greathouse-openrestys run_tests.sh
