
# Stockpot

`Stockpot` makes setting up test data in your Rails database from an external resource easier.

[![Gem Version](https://badge.fury.io/rb/stockpot.svg)](https://badge.fury.io/rb/stockpot)
<!-- [![Build Status](https://semaphoreci.com/api/v1/freshly/stockpot/branches/master/badge.svg)](https://semaphoreci.com/freshly/stockpot)
[![Maintainability](TODO)](https://codeclimate.com/github/Freshly/stockpot/maintainability)
[![Test Coverage](TODO)](https://codeclimate.com/github/Freshly/stockpot/test_coverage) -->

`Stockpot` gives you an easy way to expose a number of end points from your app, enabling CRUD actions that you can utilize from things like a standalone test suite to set up state. For instance, rather than going through the entirety of a new user creation flow just to check that users can update their data once registered, simply make a POST call to `/stockpot/database_management` with your dummy user's data, shortcutting that unnecessary setup and enabling you to go to directly checking the system behavior needed.

Use it in your external Cypress or Cucumber tests, set up a webpage to allow manual testers to set up and get state with an interface fronting the API, etc.

Why the name `Stockpot`? Keeping with Freshly's food related naming, a [stockpot](https://en.wikipedia.org/wiki/Stock_pot) is one of the most common types of cooking pots worldwide, and a stockpot is traditionally use to make stock or broth which can be the basis for cooking more complex recipes. You put ingredients in, do some cooking, and take out a finished product. For this project, think of your database as being the stockpot, putting in test data, doing some action in the system under test, and then pulling out data to use in your assertions of your system's behavior.

### Version 0.1.x Notes

Initial development notes: Stockpot is very much a work in progress. The initial implementation is _mostly_ an abstraction of Freshly's current usage of controllers to allow our external Cypress test project to interact with our Rails app's database. The current pie in the sky plan is to genericize things more so that different tools can be used and allow folk's more configuration options.

* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)