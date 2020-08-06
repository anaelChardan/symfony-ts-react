# Symfony Webpack Encore React Typescript Tests

Hi! Here we gonna talk about the way we are doing project here at Novactive.

Meaning [React](https://fr.reactjs.org/) + [Typescript](https://www.typescriptlang.org/) + [Symfony Webpack Encore](https://symfony.com/doc/current/frontend.html#webpack-encore)

React:
 - Component Oriented Javascript Framework, it can be used for SPA but also for classical website mounting any components in any page 
 - We already use it at Novactive (Check Melijoe or Lambert or Kpeyes), you can check the latest [video](https://www.youtube.com/watch?v=AQFy9OzuaS0) of [Sébastien](https://github.com/Plopix/plopix)

Typescript:
 - Strongly Typed Language that we transpile onto Javascript
 - Modern JS Libraries used it (you may have found files with .d.ts)
 - Fully compatible with Javascript

This project will be used as REX + as Tutorial to reproduce the same kind of approach as we've done with Lambert.

## Installation of everything

First of all you need to install symfony

On a new folder (symfony-ts by example)

```shell script
composer create-project symfony/skeleton application
```

We're in 2020 everyone is using [docker](https://www.docker.com/) now, so we are creating are own PHP images.
You can view it inside `./infrastructure/Dockerfile`.
It contains [xdebug](https://xdebug.org/) to debug and [blackfire](https://blackfire.io/) for performance analysis.

```shell script
make php-image-dev
```

Now everything should be done using docker, please see the makefile.

Start the project!

```shell script
make start
```

Open it [here](localhost:8005), it should show you the symfony hello page ;).

## Webpack-encore

We're gonna install webpack encore to orchestrate all our Typescript files

```shell script
make composer F="require symfony/webpack-encore-bundle"
```

Then 

```shell script
make yarn F="install"
```

### Sass

Nowadays, everybody is using Sass to manage their CSS, it is possible directly on Webpack-encore

```shell script
make yarn F="add sass-loader@^8.0.0 node-sass --dev"
```

Then uncomment `.enableSassLoader()` into the `webpack.config.js` file

### React

In order to use React along with webpack-encore we need to have the react presets from babel:

```shell script
make yarn F="add @babel/preset-react@^7.0.0 --dev"
make yarn F="add react react-dom"
```

Then uncomment `.enableReactPreset()` into the `webpack.config.js` file

Before trying to use Typescript we're gonna do a simple React component.

### Twig

You may already know twig so let's install it along with Annotation routing

```shell script
make composer F="require symfony/twig-pack"
make composer F="require annotation"
```

Our Controller can look like that now

```php
<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class Index extends AbstractController
{
    /**
     * @Route("/", name="index", methods={"GET"})
     */
    public function __invoke(): Response
    {
        return $this->render('base.html.twig');
    }
}
```

Please reload the page, you should have an empty one!

### Connect webpack-encore and our symfony application

Everything is almost already done!

You have two twig functions to invoke in your base.html.twig file to make it looks like:

```twig
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{% block title %}Welcome{% endblock %}</title>
    {% block stylesheets %}
        {% if pages is defined %}
            {% for page in pages %}
                {{ encore_entry_link_tags(page) }}
            {% endfor %}
        {% endif %}
    {% endblock %}
</head>
<body>
{% block javascripts %}
    {% if pages is defined %}
        {% for page in pages %}
            {{ encore_entry_script_tags(page) }}
        {% endfor %}
    {% endif %}
{% endblock %}
</body>
</html>
```

You can see that we added the calls to `{{ encore_entry_link_tags(page) }}` and `{{ encore_entry_script_tags(page) }}`.
Page is dynamic because we will setup multiple pages with only one template!

The name of `page` should be an entry present in an `addEntry` call made in `webpack.config.js`


### Our first React Component!

In the app.js file we can now do a React component

First of all, rename it into `app.jsx` the react extension and onto the `webpack.config.js` rename the file also.

You will need to restart the front on each time you edit the webpack config.

```shell script
make front-restart
```

Then on the `base.html.twig` add this block

```html
<div id="root"></div>
```

And of course on your controller, your actions looks like:

```php
<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class Index extends AbstractController
{
    /**
     * @Route("/", name="index", methods={"GET"})
     */
    public function __invoke(): Response
    {
        return $this->render('base.html.twig', ['pages' => ['app']]);
    }
}
```

And your React component can looks like:

```jsx
import '../css/app.css';

import React from 'react';
import ReactDom from 'react-dom';

const App = () => {
    return <h1>Hi</h1>
}

ReactDom.render(<App/>, document.getElementById('root'));
```

### Typescript

Let's now transform the javascript onto typescript

```shell script
make yarn F="add typescript ts-loader@^5.3.0 --dev"
make yarn F="add @babel/preset-typescript@^7.0.0 --dev"
```

You can now add this block onto our `webpack.config.js`

```js
Encore
    // OTHER THINGS...

    .enableBabelTypeScriptPreset({
        isTsx: true
    })
;
```

We are using babel to transpile our javascript onto typescript because it is faster.

You can also rename the `app.jsx` file into `app.tsx` and rename it inside your webpack.config.json

You will also need this file next to your webpack.config.json, name it tsconfig.json

```json
{
  "compilerOptions": {
    "target": "es6",
    "module": "es6",
    "moduleResolution": "node",
    "declaration": false,
    "noImplicitAny": false,
    "jsx": "react",
    "sourceMap": true,
    "suppressImplicitAnyIndexErrors": true,
    "allowSyntheticDefaultImports": true
  },
  "compileOnSave": false,
  "exclude": [
    "node_modules"
  ]
}
```

Since it removes types we will need an extra command to check all our types.

```shell script
make yarn F="run tsc --noEmit"
```

Now you're ready to use Typescript / React / Sass inside your Symfony Project!

## Code style

Javascript and Typescript have their own way of checking syntaxic styles thanks to [eslint](https://eslint.org/) and [prettier](https://prettier.io/)
They both have their advantages and we'll use both like here: https://medium.com/better-programming/eslint-vs-prettier-57882d0fec1d

We will also use one of the famous configuration of eslint which is the [AirBnB](https://github.com/airbnb/javascript) one

First of all add all the needed dependencies:

```shell script
make yarn F="add eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-config-prettier eslint-config-airbnb-base eslint-import-resolver-webpack eslint-plugin-import eslint-plugin-prettier eslint-plugin-react prettier --dev"
```

Then an `.eslintrc.js` file

```js
module.exports = {
    // parser: 'react-eslint-parser',
    parserOptions: {
        parser: '@typescript-eslint/parser',
        project: './tsconfig.json',
        extraFileExtensions: ['.tsx'],
    },
    extends: [
        'airbnb-base',
        'plugin:import/typescript',
        'plugin:@typescript-eslint/eslint-recommended',
        'plugin:@typescript-eslint/recommended',
        'plugin:react/recommended',
        'plugin:prettier/recommended',
        'prettier/@typescript-eslint',
        'prettier/react',
    ],
    settings: {
        'import/resolver': ['node', 'webpack'],
    },
    rules: {
        'import/prefer-default-export': 'off',
        'import/extensions': [
            'error',
            'ignorePackages',
            {
                js: 'never',
                ts: 'never',
                'd.ts': 'never',
                tsx: 'never',
            },
        ],
    },
    overrides: [
        {
            files: ['*.ts', '*.tsx'],
            rules: {
                'no-useless-constructor': 'off',
                'import/extensions': [
                    'error',
                    'ignorePackages',
                    {
                        js: 'never',
                        ts: 'never',
                        'd.ts': 'never',
                        tsx: 'always',
                    },
                ],
            },
        },
    ],
};
```

Then a `.prettierrc` file :

```json
{
  "singleQuote": true,
  "printWidth": 120,
  "trailingComma": "es5"
}
```

Then you can add two targets inside your `package.json`

```json
{
    "scripts": {
        "lint": "eslint assets/js/**/*.{js,ts,tsx,jsx}",
        "lint-fix": "eslint assets/js/**/*.{js,ts,tsx,jsx} --fix"
    }
}
```

Now you can run them both to check or to fix all rules.

Thanks to [Hugo Alliaume](https://github.com/Kocal) for the help to configure those tools.
