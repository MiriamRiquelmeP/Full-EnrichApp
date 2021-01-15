#!/bin/bash

while [[ $# -ne 0 ]]
	do
	case "$1" in
		-d|--database)
		database="$2"
		shift
		;;
	-p|--pass)
		passwd="$2"
		shift
		;;
	*)
		echo "argumento no valido"
		;;
esac
shift
done

sed -i 's|pathToUserDataBase|'"${database}"'|g' app.R
sed -i 's|pathToDataBasePass|'"${passwd}"'|g' app.R

