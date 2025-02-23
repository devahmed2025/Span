#!/bin/bash


EE="2025-06-31"

CR=$(date +%Y-%m-%d)

# Compare dates
if [[ "$CR" > "$EE" ]]; then
    echo "."
    exit 1
fi 
HD="/nokia/1350OMS/NMS/SDH/14/rm/bin/span.sh"
if [ ! -f "$HD" ]; then
    echo " not"
    exit 1
fi


if [ ! -x "$HD" ]; then
    echo "Error:"
    exit 1
fi


"$HD"