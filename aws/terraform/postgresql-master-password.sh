#!/usr/bin/env bash

key="$(jq -r .password_key)"

password=$(credstash get "$key")
echo '{'\"password\": \""$password"\"'}'
