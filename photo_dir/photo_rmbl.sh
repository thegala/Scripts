#!/bin/sh

# Deletes broken symlinks needed before update this direcotry or db
find -L . -type l -print0 | xargs -0 rm
