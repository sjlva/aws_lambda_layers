#!/bin/bash
source functions/functions.sh

FILE=requirements.txt

empty_or_inexistent_file $FILE
get_python_runtime
get_layer_name
create_layer
finish_assistant
