#!/bin/bash

#
#    Created by ABacker on 5/15/2016
#

LIB_FILE="library"


function PrintMain {
    clear
    echo "Linux Library - MAIN MENU"
    echo "   0:EXIT this program"
    echo "   1:EDIT Menu"
    echo "   2:REPORTS Menu"
}

function PrintRecords {
    #echo "$1"

    if [ -z "$1" ]
    then
	echo "No matches!"
	PAUSE
	return 0
    fi

    count=1
    IFS="
"
    for line in `echo "$1"`
    do
	echo book${count}:

	_title=`echo $line | cut -d ":" -f1`
	_author=`echo $line | cut -d ":" -f2`
	_category=`echo $line | cut -d ":" -f3`
	_status=`echo $line | cut -d ":" -f4`
	_bname=`echo $line | cut -d ":" -f5`
	_date=`echo $line | cut -d ":" -f6`

	if [ "$2" = "UPDATE_STATUS_MODE" ]
	then
	    echo '            Title:'$_title
	    echo '           Author:'$_author
	    echo '         Category:'$_category
	    echo '           Status:'$_status

	    if [ $_status = "out" ]
	    then
		echo '   Checked out by:'$_bname
		echo '             Date:'$_date
		echo ''
		echo '       New status:in'
		echo $_title:$_author:$_category:in:: >> $LIB_FILE
	    else
		echo '       New status:out'

		read -p '   Checked out by>' _bname
		_date=$(date +%m/%d/%Y)
		echo '             Date:'$_date
		echo $_title:$_author:$_category:out:$_bname:$_date >> $LIB_FILE
	    fi
	else
	    echo '      Title:'$_title
	    echo '     Author:'$_author
	    echo '   Category:'$_category
	    echo '     Status:'$_status

	    if [ $_status = "out" ]
	    then
		echo '      Bname:'$_bname
		echo '       Date:'$_date
	    fi
	fi
	let "count+=1"
    done

    return $count
}

function EDIT_ADD {
    while true
    do
	clear
	echo "Linux Library - ADD MODE"
	read -p "   Title>" _title
	read -p "  Author>" _author
	read -p "Category>" _category

	while true
	do
	    read -p "  Status>" _status
	    if [ $_status = "out" ]
	    then
		read -p "   bname>" _bname
		read -p "    date>" _date
		break
	    elif [ $_status = "in" ]
	    then
		break
	    else
		echo 'Book status is either "in" or "out"'
	    fi
	done

	echo $_title:$_author:$_category:$_status:$_bname:$_date>>$LIB_FILE

	read -p "Any more to add, Y/N?" _choice
	if [ $_choice = "n" -o $_choice = "N" ]
	then
	    break
	fi
    done
}

function EDIT_DELETE {
    while true
    do
	clear
	echo "Linux Library -DELETE MODE"
	read -p "Enter the author/title>" _authorOrtitle

	_result="$(grep "${_authorOrtitle}" $LIB_FILE)"
	PrintRecords "$_result"
	if [ $? -gt 0 ]
	then
    	    read -p "Delete these book(s),Y/N?" _choice
    	    if [ $_choice = "y" -o $_choice = "Y" ]
	    then
		grep -v "${_authorOrtitle}" $LIB_FILE > _libfile.tmp
		mv _libfile.tmp $LIB_FILE
	    fi
	fi

	read -p "Any more to delete, Y/N?" _choice
	if [ $_choice = "n" -o $_choice = "N" ]
	then
            break
	fi
    done
}

function EDIT_DISPLAY {
    while true
    do
	clear
	echo "Linux Library -DISPLAY MODE"
	read -p "Enter the author/title>" _authorOrtitle

	_result="$(grep "${_authorOrtitle}" $LIB_FILE)"
	PrintRecords "$_result"

	read -p "Any more to look for, Y/N?" _choice
	if [ $_choice = "n" -o $_choice = "N" ]
	then
            break
	fi
    done
}

function EDIT_UPDATE_STATUS {
    while true
    do
	clear
	echo "Linux Library -UPDATE STATUS MODE"
	read -p "Enter the author/title>" _authorOrtitle

	_result="$(grep "${_authorOrtitle}" $LIB_FILE)"

 	grep -v "${_authorOrtitle}" $LIB_FILE > _libfile.tmp
      	mv _libfile.tmp $LIB_FILE

	PrintRecords "$_result" "UPDATE_STATUS_MODE"

	read -p "Any more to update, Y/N?" _choice
	if [ $_choice = "n" -o $_choice = "N" ]
	then
            break
	fi
    done
}

function EDIT {
    while true
    do
	clear
	echo "Linux Library - EDIT MENU"
	echo "   0:RETURN to the main menu"
	echo "   1:ADD"
	echo "   2:UPDATE STATUS"
	echo "   3:DISPLAY"
	echo "   4:DELETE"
	echo -n ">"
	read -n1 _choice
	case $_choice in
	    0) break;;
	    1) EDIT_ADD;;
	    2) EDIT_UPDATE_STATUS;;
	    3) EDIT_DISPLAY;;
	    4) EDIT_DELETE;;
	    *) echo ""
	       echo "Wrong Input. Try againg."
	       PAUSE;;
	esac
    done
}

function REPORTS {
    clear
    PrintRecords "$(cat $LIB_FILE)" | more
    PAUSE
}

function ERROR {
    echo error
}

function PAUSE {
    echo ""
    echo "Press any key to continue..."
    read -n1
}

function MAIN {
    clear
    echo "Linux Library Manager"
    echo ""
    echo "This is the Linux Library application"
    PAUSE

    while true
    do
	PrintMain
	
	echo -n ">"
	read -n1 _choice
	case $_choice in
	    0) exit 0;;
	    1) EDIT;;
            2) REPORTS;;
            *) echo ""
	       echo "Wrong Input. Try againg."
	       PAUSE;;
	esac
    done
}

MAIN
