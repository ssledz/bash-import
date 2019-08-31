#!/bin/bash

BASH_REP=https://raw.githubusercontent.com/ssledz/bash-repo/master

source <(curl -s $BASH_REP/__import.sh 2>/dev/null)

import pl.softech/fun/1.0.0 as f
import pl.softech/fun/2.3 as g

f.list 1 2 3 4 | f.join , '[' ']'
f.list {1..4} | f.sum

g.list 1 2 3 | g.map echo
