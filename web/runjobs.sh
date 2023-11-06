#!/bin/bash

ROOT_DIRECTORY=/orsee
ORSEEROOT=/var/www/html$ROOT_DIRECTORY
PHPEXECUTABLE=/usr/local/bin/php
SHELL=/bin/sh

test -r $ORSEEROOT/admin/cron.php && cd $ORSEEROOT/admin && $PHPEXECUTABLE -q $ORSEEROOT/admin/cron.php >> /proc/1/fd/1 2>&1
