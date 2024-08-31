#!/bin/bash

function to_uppercase() {
        echo "$1" | tr '[:lower:]' '[:upper:]'
}

ip_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $1}')
name_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $2}')

name_target=$(to_uppercase "$name_target")

        if [ $ip_target ] && [ $name_target ]; then
                echo "%{F#ffffff} 什%{F#ffffff} $ip_target - $name_target "
        elif [ $(cat ~/.config/polybar/shapes/scripts/target | wc -w) -eq 1 ]; then
                echo "%{F#ffffff} 什%{F#ffffff} $ip_target "
        else
                echo "%{F#ffffff} 什%{u-}%{F#ffffff} No target "
        fi
