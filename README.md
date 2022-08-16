<div align="center">

# Laravel Template

A Laravel project template to save you time and energy.

[![Licence](https://img.shields.io/github/license/komandar/laravel-template)](LICENSE)

<img src="https://raw.githubusercontent.com/komandar/assets/main/src/laravel-template/showcase.png" alt="Showcase">

</div>

Laravel projects take a long time to setup with all the various files and keeping things uniform across projects. With this Laravel template, you can quickly setup boilerplate code and miscellaneous items for your Laravel project saving you time and energy so you can get back to coding.

## Install

Click the `Use this template` button at the top of this project's GitHub page, it looks like this:

<img src="https://raw.githubusercontent.com/komandar/assets/main/src/global/use_template_button.png" alt="Showcase">

## Usage

**Easy text replacements**

Once Laravel is installed, replace text as needed throughout the project:

1. Replace all instances of `app` with the name of your project
2. Update name in `LICENSE`
3. Update the `CHANGELOG`
4. Delete this `README` and use the `README.md.dist` one for your project

## Install

```bash
# Run the setup script
./setup.sh
```

## Deploy

```bash
# Deploy the project locally
docker compose up -d

# Deploy the project in production
docker compose -f docker-compose.yml -f docker-compose-prod.yml up -d
```

## Development

The following commands may need to be manually added before they're ready to use.

```bash
# Install dependencies
composer install

# Migrate the database
composer migrate
composer migrate-fresh

# Clean the database
composer db-clean

# Seed the database
composer seed

# Lint the PHP files
composer lint

# Compile SASS and Javascript during development
npm run dev

# Compile for production
npm run prod

# Watch for CSS and Javascript changes
npm run watch
```
