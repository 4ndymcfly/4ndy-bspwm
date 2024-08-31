#!/bin/bash

cat ~/.config/polybar/shapes/scripts/target | awk '{print $1}' | tr -d '\n' | xclip -sel clip
