#!/bin/bash

. "$TM_BUNDLE_SUPPORT/lib/flex_utils.sh";

OS=$(defaults read /System/Library/CoreServices/SystemVersion ProductVersion)

function checkForSpaces {
	if [[ "$1" != "$2" ]]; then
		echo "Warning fsch cannot handle paths containing a space."
		echo " "
		echo "/path_to/app.mxml works"
		echo "/path to/app.mxml fails as there is a space between path and to"
		echo " "
		echo "The path that caused the problem was"
		echo " "
		echo "$1"
		echo " "
		echo "See bundle help for more information."		
		exit 206;
	fi	
}

#Only check for iTerm when the OS is Tiger.
if [[ "$OS" == 10.4.* ]]; then
	
	if find_app >/dev/null iTerm; then
		#All is ok.
		do_nothing_variable="TODO remove this by checking the negative"
	else
		echo "This command requires iTerm to be installed."
		echo "See bundle help for more information."
		exit 206;
	fi

fi

#search for the flex install directory.
set_flex_path -t

#Set and cd to TM_PROJECT_DIR 
cd_to_tmproj_root

FCSH=$(echo "$TM_FLEX_PATH/bin/fcsh" | sed 's/ /\\ /g');

ENV_MXMLC_ARGS=$(ruby -e "require '$TM_PROJECT_DIR/tm_mxmlc_config.rb'; get_mxmlc_args('$MXMLC_ENV', '$TM_PROJECT_DIR')" )

if [ "$ENV_MXMLC_ARGS" != "" ]; then
	MXMLC_ARGS="mxmlc $ENV_MXMLC_ARGS"
	echo $MXMLC_ARGS
fi


if [[ "$OS" != 10.4.* ]]; then
  "$TM_BUNDLE_SUPPORT/lib/fcsh_terminal" "$FCSH" "$MXMLC_ARGS" >/dev/null
else
	osascript "$TM_BUNDLE_SUPPORT/lib/fsch_iTerm.applescript" "$FCSH" "$MXMLC_ARGS" >/dev/null;
fi




exit 200;
