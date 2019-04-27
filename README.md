# Older Coders

<p align="center">
  <a href="https://www.ruby-lang.org/en/">
    <img src="https://img.shields.io/badge/Ruby-v2.6.1-green.svg" alt="ruby version"/>
  </a>
  <a href="http://rubyonrails.org/">
    <img src="https://img.shields.io/badge/Rails-v6.0.0.rc1-brightgreen.svg" alt="rails version"/>
  </a>
</p>

Welcome to the [oldercoders.net](https://oldercoders.net) codebase, and thank you for stopping by!

## What is Older Coders?

[Older Coders](https://oldercoders.net) aims to be a community for developers who have been at it a while, but are starting to feel the pressures and implicit biases of being the aging veteran amongst their younger peers. It will be where older coders go to connect, commiserate, organize, and find work with companies who value their maturity and experience.

## Table of Contents

- [Older Coders](#older-coders)
  - [What is Older Coders?](#what-is-older-coders)
  - [Table of Contents](#table-of-contents)
  - [Codebase](#codebase)
    - [The stack](#the-stack)
    - [Engineering standards](#engineering-standards)
      - [Style Guide](#style-guide)
      - [CSS](#css)
      - [Pre-Commit Hooks](#pre-commit-hooks)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Standard Installation](#standard-installation)
    - [Local Database Setup](#local-database-setup)
      - [Setup `DATABASE_URL` in application.yml](#setup-databaseurl-in-applicationyml)
    - [Suggested Workflow](#suggested-workflow)
  - [Frontend Code](#frontend-code)
    - [Components](#components)
      - [Generating new Components](#generating-new-components)
      - [Deleting components](#deleting-components)
    - [Global CSS, JavaScript, and Assets.](#global-css-javascript-and-assets)

## Codebase

### The stack

We run on a Rails backend with mostly vanilla JavaScript on the frontend, some of it taking advantage of [Stimulus](https://stimulusjs.org).

### Engineering standards

#### Style Guide

This project follows uses [Rubocop's](https://github.com/bbatsov/rubocop) default Rails configuration with [a few modifications](https://github.com/OlderCoders/oldercoders/blob/master/.rubocop.yml) as the Ruby code analyzer. If you have Rubocop installed with your text editor of choice, you should be up and running.

For Javascript, we follow [Airbnb's JS Style Guide](https://github.com/airbnb/javascript), using [ESLint](https://eslint.org) and [prettier](https://github.com/prettier/prettier). If you have ESLint installed with your text editor of choice, you should be up and running. 

#### CSS

For CSS, we are using straight CSS, leveraging many of the newer features in the CSS spec such as variables, custom media queries, and color functions. [PostCSS](https://postcss.org) is [configured](https://github.com/OlderCoders/oldercoders/blob/master/postcss.config.js) to compile these newer features to CSS that most browsers will understand, and also adds some syntactic sugar like nesting selectors and ancestors which will be familiar to those of who are familiar with writing [SCSS](https://sass-lang.com).

#### Pre-Commit Hooks

When commits are made, a git precommit hook runs via [lint-staged](https://github.com/okonet/lint-staged). ESLint and prettier will run on your JavaScript code before it's committed. If there are linting errors that can't be automatically fixed, the commit will not happen. You will need to fix the issue manually then attempt to commit again.

## Getting Started

This section provides a high-level requirement & quick start guide.

### Prerequisites

- [Ruby](https://www.ruby-lang.org/en/): we recommend using [rbenv](https://github.com/rbenv/rbenv) to install the Ruby version listed on the badge.
- [Yarn](https://yarnpkg.com/): please refer to their [installation guide](https://yarnpkg.com/en/docs/install).
- [PostgreSQL](https://www.postgresql.org/) 9.4 or higher.
- A process file manager, such as [Foreman](https://github.com/ddollar/foreman), [Hivemind](https://github.com/DarthSim/hivemind), or [Overmind](https://github.com/DarthSim/overmind). We prefer *Overmind*, as it allows for easier debugging.

### Standard Installation

1. Make sure all the prerequisites are installed.
2. Fork the Older Coders repository, at. https://github.com/OlderCoders/oldercoders/fork
3. Clone your forked repository, ie. `git clone https://github.com/<your-username>/oldercoders.git`
4. Set up your environment variables/secrets

   - Take a look at `.env-sample`. This file lists all the `ENV` variables we use in the application.
   - Make a copy of `.env-sample` and call it `.env`. This file will be ignored in Git.
   - Utilize your own credentials for any API keys listed in that file.
  
5. Set up your [development and test databases](#local-database-setup)
6. Run `bin/setup`
7. That's it! Run `bin/startup` to start the application and head to `http://localhost:5000/`

### Local Database Setup

By default the application is configured to connect to a local database named `older_coders_development` and `older_coders_test` for running tests. If you need to specify a username and a password you can go about it by using the environment variable `DATABASE_URL` with a connection string.

The [official Rails guides](https://guides.rubyonrails.org/configuring.html#connection-preference) go into depth on how Rails merges the existing database.yml with the connection string.

#### Setup `DATABASE_URL` in application.yml

Open your `.env` file and add the following:

```
DATABASE_URL: postgresql://USERNAME:PASSWORD@localhost
```

Replace `USERNAME` with your database username, `PASSWORD` with your database password.

You can find more details on connection strings in [PostgreSQL's own documentation](https://www.postgresql.org/docs/10/static/libpq-connect.html#LIBPQ-CONNSTRING).

NOTE: due to how Rails merges database.yml and DATABASE_URL it's recommended not to add the database name in the connection string. This will default to your development database name also during tests, which will effectively empty the development DB each time tests are run.

### Suggested Workflow

We use [Spring](https://github.com/rails/spring) and it is already included in the project.

1.  Use the provided bin stubs to automatically start Spring, i.e. `bin/rails server`, `bin/rails db:migrate`.
2.  If Spring isn't picking up on new changes, use `spring stop`. For example, Spring should always be restarted if there's a change in environment key.
3.  Check Spring's status whenever with `spring status`.

## Frontend Code

Older Coders takes something of an atypical approach for building out the front end. Most front-end code - JavaScript, CSS, and ERB Component templates all exist within the `frontend` directory. This means that you will not find an `app/assets` directory. Also, while you'll find `.erb` files in `app/views` for viewable routes, you'll see that they by in large reference components which live in the `frontend/components` directory.

### Components

Most of the views are broken into components, each of which includes an ERB file, a JavaScript file, and a CSS file.

#### Generating new Components

There's a generator for stubbing out new components. It will create the constituent component files in the directory you specify (creating the directory tree if it doesn't exist). For instance:

```
$ bundle exec rails generate component global/header
```

will create a `global/header` component as follows:

```
Running via Spring preloader in process 37709
      create  frontend/components/global/header/_header.html.erb
      create  frontend/components/global/header/header.css
      create  frontend/components/global/header/index.js
```

In order for the component specific CSS and JavaScript to be picked up by Webpack, you'll need to make sure that you `import` the component. This can be done in either `frontend/components/index.js` or the component's parent directory `index.js` file (e.g. `frontend/components/global/index.js`).

#### Deleting components

You can delete a component as easily as you can generate it:

```
$ bundle exec rails destroy component global/header
```

### Global CSS, JavaScript, and Assets.

Assets that aren't specific to a component can be found in various directories under `frontend`.

- `frontend/config` contains CSS configuration files
- `frontend/styles` contains global CSS
- `frontend/scripts` contains global JavaScript 
- `frontend/packs` contains Webpack entry files (e.g. Webpack compiles `application.js` to `application-[hash].js` and `application-[hash].css`)
- `frontend/controllers` contains Stimulus.js controllers
- `frontend/assets` contains static assets, such as fonts and images.
