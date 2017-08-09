require 'rubygems'
require 'bundler'
require 'sinatra'
Bundler.require
require './3ch'
run Sinatra::Application
