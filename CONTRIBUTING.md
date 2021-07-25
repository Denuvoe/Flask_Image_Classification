
# Contributing to Stockpot

Thank you so much for your interest in contributing to Stockpot!

## Overview

Stockpot is a [Rails Engine](https://guides.rubyonrails.org/engines.html) which means that it's "considered miniature applications that provide functionality to their host applications." It can technically be run on its own via `rails s`, but it's meant to be run inside a larger app, so running it on its own won't really provide a lot of benefit, or really work correctly at the moment. Think of Stockpot as a helpful addon to an existing Rails app that unlocks a handful of API routes to use, saving time writing them yourself.

The project's repo will look _similar_ to a Rails app, though very pared down. There's an app directory, but inside you'll only find controllers. As Stockpot is just an API that returns JSON, there's no need for views, and, for now, there's also no need for models, so you won't find them there either.

# Working with the code

## PRs

- Make sure to update the [CHANGELOG](CHANGELOG.md) with your changes.
  - Please follow the existing [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
  - Add yourself to the contributors list at the bottom so that attribute links work