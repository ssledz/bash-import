#!/bin/bash

random_str() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1
}

all_functions() {
  local src=$1
  cat <(cut -d' ' -f3 <(declare -F)) <(cat $src | grep '^[a-zA-Z0-9_]*()' \
    | cut -d '(' -f1) | sort | uniq -c | grep -v '1 ' | tr -s ' ' | cut -d' ' -f3
}

emit_function() {
  local name=$1
  local prefix=$2
  local ns=$3

  test -n "$(declare -f $1)" || return 

  cat <<EOF

${_/$name/${prefix}_$name}

$ns.$name() {
 ${prefix}__init
 ${name} \$@
}

EOF

}

emit_init() {
  local function_arr=${!1}
  local prefix=$2

  cat <<EOF

${prefix}__init() {

EOF

  for name in ${function_arr[@]}; do
  cat <<EOF
  unset -f $name
  __copy_function ${prefix}_$name $name
EOF
  done

  echo "}"

}

compile() {
  local src=$1
  local ns=$2

  source $src

  local function_arr=()
  local prefix=$(random_str)
  while read name; do
    function_arr+=($name)
    emit_function $name $prefix $ns
  done < <(all_functions $src)

  emit_init function_arr[@] $prefix

}

compile $@

