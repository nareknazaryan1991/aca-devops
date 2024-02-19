#!/bin/bash

isEmpty(){
        command_result=$(eval $2)

        if [ -z "$command_result" ]; then
                echo "No $1 found."
        else
                echo "$1 found."
        fi
}