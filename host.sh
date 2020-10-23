#!/bin/bash

bundle exec jekyll b

rsync -r _site/ heydaris.com:sites/blog_en/
