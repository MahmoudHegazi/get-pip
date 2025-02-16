echo -e "\e[34m|------------------------------------------------------------------------|"
echo -e "\e[36m|\e[32m                  Welcome Thanks For Using Get PIP                  \e[36m|\e[34m"
echo -e "|------------------------------------------------------------------------|\e[0m"


# handle inputs togther as it simple input html input "your input"
function input() {
   if [ $1 = 'filepath' ]; then
      read -p 'Enter File Path:' filepath
      echo $filepath
   elif [ $1 = 'last_imported_spliter' ]; then
      read -p 'Enter last imported line to get what after it or empty for all' last_imported_spliter
      echo "$last_imported_spliter"
   elif [ $1 = 'confirm_continue' ]; then
      read -p 'Do you Confirm Continue (yes/no)?: ' confirm
      echo "$confirm"
   fi
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
   filepath=$(input 'filepath')
   filetxt=$(cat $filepath)
   #last_imported_spliter=$(input 'last_imported_spliter')

   # convert file to lines array
   mapfile -t all_lines < $filepath


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
             echo $pip_package
         fi
      fi
   done
   confirm_continue=$(input 'confirm_continue')
   if [ "$confirm_continue" = 'yes' ];
   then
      echo 'going to start'
   else
      echo 'ok will not started ...'
   fi
}

main


#all_imports=$(awk -F "$spliter" '{print $1}' "$filepath")
#all_imports1=$(echo $imports_txt | awk -F "$spliter" '{print $1}')
#all_imports2=$(echo $imports_txt | sed "s/$spliter.*//")
#all_imports=$(awk '{p=p $0 ORS} index($0, "$pliter") {exit} END {print p}' "$filepath")
