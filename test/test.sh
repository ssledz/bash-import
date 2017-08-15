#!/bin/bash

rm -rf ~/.bash-import

BASH_REP=http://localhost/repository2

source <(curl -s $BASH_REP/__import.sh 2>/dev/null)

import pl.softech/fun/1.0 as f

f.list 1 2 3 4 | f.join , '[' ']'
f.list {1..4} | f.sum
