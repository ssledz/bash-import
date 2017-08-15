#!/bin/bash

DEFUALT_BASH_IMPORT_DIR=~/.bash-import

__copy_function() {
  test -n "$(declare -f $1)" || return 
  eval "${_/$1/$2}"
}

__rename_function() {
  copy_function $@ || return
  unset -f $1
}

__cache_modules() {
  mkdir -p $BASH_REP_DIR
  scripts=(__compile.sh __import.sh __init.sh)
  for script in ${scripts[@]}; do
    path=$BASH_IMPORT_DIR/$script
    [[ ! -e $path ]] && curl -s $BASH_REP/$script > $path && chmod +x $path
  done

}

__source_module() {
  source $BASH_IMPORT_DIR/$1
}

import() {
  local what=$1
  shift

  [[ -z $BASH_IMPORT_DIR ]] && BASH_IMPORT_DIR=$DEFUALT_BASH_IMPORT_DIR

  BASH_REP_DIR=$BASH_IMPORT_DIR/rep

  __cache_modules

  local package=$(echo $what | cut -d'/' -f1)
  local artifact=$(echo $what | cut -d'/' -f2)
  local version=$(echo $what | cut -d'/' -f3)
  local path=$(echo $package | tr '.' '/')/$artifact/$version

  __source_module __init.sh
  __init "$path" "$@"
}
