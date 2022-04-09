#!/bin/bash

is_debug_enabled=0

## log color 
red='\e[0;41m' 
RED='\e[1;31m'

green='\e[0;32m' 
GREEN='\e[1;32m'

yellow='\e[5;43m' 
YELLOW='\e[1;33m'

blue='\e[0;34m' 
BLUE='\e[1;34m'

purple='\e[0;35m' 
PURPLE='\e[1;35m'

cyan='\e[4;36m'  
CYAN='\e[1;36m'

WHITE='\e[1;37m' 

nc='\e[0m' # restore the default color
NC='\e[0m' 

## base log
function log {
    echo -e "$*"
}

## debug log
function logd {
    if [ $is_debug_enabled == 1 ]; then
        echo [dbg] $*;
    fi
}

## error log
function loge {
    log "${red}[err] $*${nc}"
}

## warning log
function logw {
    log "${YELLOW}[war] $*${nc}"
}

## running log
function logr {
    log "${GREEN}$*${nc}"
}