__init() {

  trim() {
    echo -n $(cat -)
  }

  local path=$1
  local ns=$3
  local url=$BASH_REP/$path

  root=$(pwd)
  cd $BASH_REP_DIR
  mkdir -p $path
  init_file=$path/__init

  curl -s $url/__init > $init_file
  while read line; do
    key=$(echo $line | cut -d':' -f1 | trim)
    value=$(echo $line | cut -d':' -f2 | trim)
    case $key in
        "copy")
            for file in $(echo $value | tr ',' '\n'); do
               [[ ! -e $path/$file ]] && curl -s $url/$file > $path/__$file
               ../__compile.sh $path/__$file  $ns > $path/$file
            done
            ;;
        "source")
            for file in $(echo $value | tr ',' '\n'); do
                source $path/$file
            done
            ;;
    esac
  done < <(cat $init_file | sort)
  cd $root
}
