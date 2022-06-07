empty_or_inexistent_file () {
  if [ ! -s "$FILE" ]
  then
      whiptail --title "$FILE found or empty" --msgbox "Please make sure $FILE and is not empty." --fb 10 50
      exit
  fi
}

get_python_runtime () {
  local runtime=$(whiptail --title "Python Runtime" --menu "Choose a compatible runtime" --fb 15 50 4 \
    1 "python3.6" \
    2 "python3.7" \
    3 "python3.8" \
    4 "python3.9" 3>&1 1>&2 2>&3)

  status=$?
  if [ $status = 0 ]; then
    py_version=python3.$(($runtime+5))
  else
    exit
  fi
}

get_layer_name () {
  layer_name=$(whiptail --title "Layer Name" --inputbox "Type the layer name:" --fb 10 60 3>&1 1>&2 2>&3)
  statussaida=$?
  if [ $statussaida != 0 ]
  then
    exit
  fi
}

create_layer () {
  {
    echo -e "XXX\n0\n creating virtual environment...\nXXX"
    mkdir python
    cd python
    $py_version -m venv tmp_env
    source "tmp_env/bin/activate"
    echo -e "XXX\n20\n installing python packages...\nXXX"
    pip install --upgrade pip
    pip install -r ../$FILE -t . 
    echo -e "XXX\n75\n creating zip file...\nXXX"
    zip -r $layer_name.zip .
    mv $layer_name.zip ..
    echo -e "XXX\n95\n removing files...\nXXX"
    cd ..
    rm --recursive --force python
    echo -e "XXX\n100\n Done.\nXXX"
  } | whiptail --title "Creating Layers" --gauge "Please wait" 6 60 0
}

finish_assistant () {
  whiptail --title "Success" --msgbox "Done. $layer_name.zip created successfully." --fb 10 50
}

