#!/usr/bin/env bash
set -eo pipefail

sudo nmap -n -sP 192.168.0.0/24 | awk '/Nmap scan report/{printf $5;printf " ";getline;getline;print $3;}' > test.txt