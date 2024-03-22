#!/bin/bash

create_matrix_object () {
  (echo [{ \"name\": \"$1\", \"version\": && cat && echo }]) <<< $(curl $2 | grep -zPoh -m 1 -- '\d+[.-]*' | tr -d '\n' | tr -d '\0' | awk '{ print "\""$0"\""}') | jq -c .
}

merged_array=$(echo $(create_matrix_object "lxd" "https://raw.githubusercontent.com/ganto/copr-lxc4/51bd8355fc7216837323ef2d0babbe95bd65338d/.tito/packages/lxd") | jq ". + $(create_matrix_object "incus" "https://raw.githubusercontent.com/ganto/copr-lxc4/51bd8355fc7216837323ef2d0babbe95bd65338d/.tito/packages/incus")")
generated_matrix=$(echo {\"packages\":$merged_array} | jq -c .)
echo $generated_matrix
echo "matrix=$generated_matrix" >> $GITHUB_OUTPUT