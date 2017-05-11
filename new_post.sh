#!/bin/bash

NAME=_drafts/$(date -I)-$1.markdown
touch $NAME
echo $NAME
