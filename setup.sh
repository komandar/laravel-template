#!/bin/bash

# This script prepares the initial installation.
# To start the project in the future, simply run `docker compose up -d`

main() {
    # Join right folder
    cd src || exit 1

    # Install required dependencies
    composer install
    npm install

    # Generate a Laravel key
    php artisan key:generate

    cd .. || exit 1

    # Spin up the project
    docker compose up -d --build --quiet-pull

    cd src || exit 1

    # TODO: Uncomment if your project has a DB
    # Run database migrations once the database container is up and able to accept connections
    # echo "Waiting for database container to boot before migrating and seeding..."
    # sleep 15
    # composer migrate-seed
}

main
