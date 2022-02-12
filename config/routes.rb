# frozen_string_literal: true

Stockpot::Engine.routes.draw do
  get "/records", to: "records#index"
  post "/records", to: "records#crea