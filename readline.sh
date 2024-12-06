#! /usr/bin/env bash
# source: readline.sh
# Copyright Gerhard Rieger and contributors (see file CHANGES)
# Published under the GNU General Public License V.2, see file COPYING

# this is an attempt for a socat based readline wrapper
# usage: readline.sh <command>

withhistfile=1

while true; do
    case "X$1" in
    X-nh|X-nohist*) withhistfile=; shift; continue ;;
    *) break;;
    esac
done

PROGRAM="$@"
if [ "$withhistfile" ]; then
    HISTFILE="$HOME/.$1_history"
    HISTOPT=",history=$HISTFILE"
else
    HISTOPT=
fi
#
#

if test -w .; then
    STDERR=./socat-readline.${1##*/}.log
    rm -f $STDERR
else
    STDERR=/dev/null
fi

exec socat -d readline"$HISTOPT",noecho='[Pp]assword:' exec:"$PROGRAM",sigint,pty,setsid,ctty,raw,echo=0,stderr 2>$STDERR

