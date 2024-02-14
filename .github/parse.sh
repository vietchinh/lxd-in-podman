#!/bin/bash

create_matrix_object () {
  (echo [{ \"name\": \"$1\", \"version\": && cat && echo }]) <<< $(curl $2 | grep -zPoh -m 1 -- "\d+.\d+-\d+.\d+\n" | head -1 | tr -d '\n' | tr -d '\0' | awk '{ print "\""$0"\""}') | jq -c .
}

merged_array=$(echo $(create_matrix_object "lxd" "https://raw.githubusercontent.com/ganto/copr-lxc4/master/lxd/lxd.spec") | jq ". + $(create_matrix_object "incus" "https://raw.githubusercontent.com/ganto/copr-lxc4/master/incus/incus.spec")")
generated_matrix=$(echo {\"versions\":$merged_array} | jq -c .)
echo "matrix=$generated_matrix" >> $GITHUB_OUTPUT