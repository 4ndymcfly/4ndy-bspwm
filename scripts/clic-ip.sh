#!/bin/bash

echo $(/usr/sbin/ifconfig eth0 | grep "inet " | awk '{print $2}') | tr -d '\n'| xclip -sel clip
