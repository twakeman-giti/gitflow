
#!/bin/bash

# git-flow make-less installer for *nix systems, by Rick Osborne
# Based on the git-flow core Makefile:
# http://github.com/nvie/gitflow/blob/master/Makefile

# Licensed under the same restrictions as git-flow:
# http://github.com/nvie/gitflow/blob/develop/LICENSE

# Does this need to be smarter for each host OS?
if [ -z "$INSTALL_PREFIX" ] ; then
	INSTALL_PREFIX="/usr/local/bin"
fi

if [ -z "$INSTALL_TMP" ] ; then
    INSTALL_TMP="/tmp/gitflow"
fi

if [ -z "$REPO_NAME" ] ; then
	REPO_NAME="gitflow"
fi

if [ -z "$REPO_HOME" ] ; then
	REPO_HOME="http://github.com/nvie/gitflow.git"
fi

EXEC_FILES="git-flow"
SCRIPT_FILES="git-flow-init git-flow-feature git-flow-hotfix git-flow-release git-flow-support git-flow-version gitflow-common gitflow-shFlags"
SUBMODULE_FILE="shFlags"

echo "### gitflow no-make installer ###"

case "$1" in
	uninstall)
		echo "Uninstalling git-flow from $INSTALL_PREFIX"
		if [ -d "$INSTALL_PREFIX" ] ; then
			for script_file in $SCRIPT_FILES $EXEC_FILES ; do
				echo "rm -vf $INSTALL_PREFIX/$script_file"
				rm -vf "$INSTALL_PREFIX/$script_file"
			done
		else
			echo "The '$INSTALL_PREFIX' directory was not found."
			echo "Do you need to set INSTALL_PREFIX ?"
		fi
		exit
		;;
	help)
		echo "Usage: [environment] gitflow-installer.sh [install|uninstall]"
		echo "Environment:"
		echo "   INSTALL_PREFIX=$INSTALL_PREFIX"
		echo "   REPO_HOME=$REPO_HOME"
		echo "   REPO_NAME=$REPO_NAME"
		exit
		;;
	*)
		echo "Installing git-flow to $INSTALL_PREFIX"
        if [ ! -d "$INSTALL_TMP" ] ; then
            echo "Creating tmp dir for gitflow install"
            mkdir -pv $INSTALL_TMP
        fi
        pushd $INSTALL_TMP
        echo "$PWD"
		if [ -d "$INSTALL_TMP/$REPO_NAME" -a -d "$INSTALL_TMP/$REPO_NAME/.git" ] ; then
			echo "Using existing repo: $REPO_NAME"
		else
			echo "Cloning repo from GitHub to $INSTALL_TMP/$REPO_NAME"
			git clone "$REPO_HOME" "$INSTALL_TMP/$REPO_NAME"
		fi
		if [ -f "$INSTALL_TMP/$REPO_NAME/$SUBMODULE_FILE" ] ; then
			echo "Submodules look up to date"
		else
			pushd $INSTALL_TMP/$REPO_NAME
			if [[ ! -z "$INSTALL_TMP/$SUBMODULE_FILE" ]];
			then
				echo "Removing bad submodule URL"
				git rm $INSTALL_TMP/$SUBMODULE_FILE
			fi
			echo "Adding Submodule: $INSTALL_TMP/$SUBMODULE_FILE"
			git submodule add https://github.com/nvie/shFlags.git
			pushd $INSTALL_TMP/$REPO_NAME/$SUBMODULE_NAME
			git submodule init
			git submodule update
			popd #SUBMODULE_FILE
			popd #REPO_NAME
        fi
		install -v -d -m 0755 "$INSTALL_PREFIX"
		for exec_file in $EXEC_FILES ; do
			install -v -m 0755 "$REPO_NAME/$exec_file" "$INSTALL_PREFIX"
		done
		for script_file in $SCRIPT_FILES ; do
			install -v -m 0644 "$REPO_NAME/$script_file" "$INSTALL_PREFIX"
		done
        popd #$INSTALL_TMP
		exit
		;;
esac
