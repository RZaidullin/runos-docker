#!/bin/bash

[ -f ~/.bashrc ] && . ~/.bashrc

# go to mounted directory
cd /userdata

if [ -d runos ]; then 
        echo '-> Found runos directory in here, apply debug envs...'
        mkdir -p runos/build && cd runos/build
        source ../debug_run_env.sh
        cd ../../
elif [ -f ./debug_run_env.sh ]; then
        echo '-> Found myself in runos directory, applying debug envs...'
        mkdir -p build && cd build
        source ../debug_run_env.sh
        cd ../
else
        echo '-> WARNING: No runos directory found here, you need to run "source ../debug_run_env.sh" by yourself'
fi

PATH=/userdata/drunos/build:$PATH
PATH=/userdata/orig-runos/build:$PATH
service openvswitch-switch start


# use bash-completion
. /etc/bash_completion
alias ovs-ofctl="ovs-ofctl -OOpenFlow13"
