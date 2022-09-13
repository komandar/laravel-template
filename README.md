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

1. Replace all instances of `appname` with the name of your project
2. Update name in `LICENSE`
3. Update the `CHANGELOG.md`
4. Delete this `README.md` and use the `README.md.dist` one for your project

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
docker compose -f docker-compose-prod.yml up -d
```
