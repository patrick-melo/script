#!/bin/bash
################################################################################
#
#+ P(1)                          Patrick Scripts                            P(1)
#+ 
#+ NNAAMMEE
#+       p - administer macOS with impunity
#+
#+ SSYYNNOOPPSSIISS
#+       p [command] [OPTION]...
#+
#+ DDEESSCCRRIIPPTTIIOONN
#+       P is a script to with the administration of Mac machines.
#+
#+ AARRGGUUMMEENNTTSS
#+       If no commands are provided then the usage is displayed. This script
#+       accepts the following commands. Commands containing a † have required
#+       dependencies.
#+
# STYLE:
# Use the following as a style guide: https://google.github.io/styleguide/shell.xml
# Use `man man` (which indents 7 spaces) as an example for the help command.

usage() { echo "Usage: $@" ; exit 1; }

error() { RED='\033[0;31m' ; NC='\033[0m' ; printf "${RED}$@${NC}\n" ; exit 1 ; }

folder() { printf '%q\n' "${PWD##*/}"; }

pause() { echo -n "Press any key to continue . . ." ; read -sn1 response ; echo ; }

cmd() {
    cmd=$1 ; shift
    
    usage=cmd_${cmd}_@usage

    # subcmd not specified: call usage
    if [[ -z $1 && $(type -t $usage) == function ]] ; then
        $usage
    else
        subcmd=cmd_${cmd}_$1
        default=cmd_${cmd}_@default

        # subcmd specified and exists: call subcmd
        if [[ $(type -t $subcmd) == function ]] ; then
            shift
            $subcmd "$@"
        
        # subcmd specified and NOT exists but default exists: call default
        elif [[ $(type -t $default) == function ]] ; then
            $default "$@"

        # subcmd specified and NOT exists and default NOT exists: error
        else
            echo "Invalid command."
        fi
    fi
}

#+       debug [command]
#+              Debug a g command.
#+
cmd_debug() { bash -x $THIS "$@" ; }

#+       help
#+              View the help documentation.
#+
cmd_help() { grep -h "^#+" $THIS | cut -c4- | less -is ;}

#+       update
#+              Update this script file.
#+
cmd_update() { curl https://raw.githubusercontent.com/patrick-melo/script/main/bin/p.sh > $SCRIPT ;} 

main() {
    cmd=$1 ; shift
    if [[ $(type -t cmd_$cmd) == function ]] ; then
        cmd_$cmd "$@"
    else
        usage "$SCRIPT [ 'help' | command ]"
    fi
}

for script in $(dirname $BASH_SOURCE)/includes/*.sh ; do
    . "$script"
done
THIS_DIR=$( cd "$(dirname "$0")" >/dev/null 2>&1 ; cd ../ ; pwd )
THIS=$THIS_DIR/bin/p.sh
SCRIPT=$(basename $0 .sh)
main "$@"
