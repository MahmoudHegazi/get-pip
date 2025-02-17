echo -e "\e[34m|------------------------------------------------------------------------|"
echo -e "\e[36m|\e[32m                  Welcome Thanks For Using Get Imports                  \e[36m|\e[34m"
echo -e "|------------------------------------------------------------------------|\e[0m"

dev_loaded_packages=()
current_loaded_packages=()

dev_packages=()
# what used now for both and work as native bash and same method main for both generate command install from dev by process it files python
current_packages=()
# right now same prod can handle both
current_required_pip=()
pip_install_command=""



# handle inputs togther as it simple input html input "your input"
function input() {
   if [ $1 = 'filepath' ]; then
      read -p 'Enter File Path:' filepath
      echo $filepath
   elif [ $1 = 'last_imported_spliter' ]; then
      read -p 'Enter last imported line to get what after it or empty for all' last_imported_spliter
      echo "$last_imported_spliter"
   elif [ $1 = 'pip_command_needed' ]; then
      read -p 'Do you need get-pip display pip install command with all packages on this machine for speacfied file with the versions (usally do that on exporter like export command to done on prod) Continue (yes/no)?: ' pip_command_needed
      echo "$pip_command_needed"
   elif [ $1 = 'confirm_continue' ]; then
      read -p 'Do you Confirm Continue (yes/no)?: ' confirm
      echo "$confirm"
   fi
}

error_msg() {
    echo -e "\e[31m$1\e[0m"  # Print in red
}

# return pip package or empty
function get_pip_arg() {
   any_package="$(awk '{print $2}' <<< "$1")"
   if [[ "$any_package" != .* ]]; then
      echo "$(awk -F '.' '{print $1}' <<< "$any_package")"
   else
      echo ''
   fi
}




function main() {
   pip_packages=()

   filepath=$(input 'filepath')
   filetxt=$(cat $filepath)
   #last_imported_spliter=$(input 'last_imported_spliter')

   # convert file to lines array
   mapfile -t all_lines < $filepath || error_msg


   echo -e "\e[31m-------------------Check Your Input--------------------\e[0m"
   f30="$(echo "$filetxt" | head -n 30)"
   echo "Content: $f30"
   echo ""
   echo -e "\e[32m#######################\e[0m"
   echo "Filename: $filepath"
   echo ""
   echo -e "\e[30m-------------------what will Proccessed-----------------\e[0m"
   printf '%s' "$all_imports"
   echo ""
   echo -e "\e[36m-------------------End Check----------------------------\e[0m"

   # loop over lines and check if it python syntax import of package (it strictly can handle secure any python file and any import syntax
   for line in "${all_lines[@]}"; do
      if [[ $line = import* || $line = from* ]]; then
         # now this pip relative package not need pip or target package need pip
         pip_package=$(get_pip_arg "$line")
         if [[ "$pip_package" != '' ]]; then
            current_loaded_packages+=("$pip_package")
            echo $pip_package
         fi
      fi
   done
   confirm_continue=$(input 'confirm_continue')
   if [ "$confirm_continue" = 'yes' ];
   then
      for package in "${current_loaded_packages[@]}"; do
         #echo pip show "$package" &>/dev/null
         package_version=$(pip show "$package" | grep -i '^Version' | awk '{print $2}')
         if [ -n "$package_version" ]; then
            # using command pip generate is handle dynamic os packages ignored or any not exist package
            current_packages+=("$package ($package_version)")
            current_required_pip+=("$package"=="$package_version")
            echo -e "\e[34m '$package' installed with version "$package_version" \e[0m"
         else
            current_packages+=("$package (0)")
            echo -e "\e[31mPackage '$package' is not installed.\e[0m"
         fi
      done
      echo 'going to start'
      pip_install_command="pip install $(IFS=' '; echo "${current_required_pip[*]}")"
      echo -e "\e[32mPIP_____________________PIP\e[0m"
      echo "$pip_install_command"
      echo -e "\e[32mPIP_____________________PIP\e[0m"
      echo "Updated current_packages: ${current_packages[@]}"
   else
      echo 'ok will not started ...'
   fi
}

main


#all_imports=$(awk -F "$spliter" '{print $1}' "$filepath")
#all_imports1=$(echo $imports_txt | awk -F "$spliter" '{print $1}')
#all_imports2=$(echo $imports_txt | sed "s/$spliter.*//") loader friendly
#all_imports=$(awk '{p=p $0 ORS} index($0, "$pliter") {exit} END {print p}' "$filepath")
