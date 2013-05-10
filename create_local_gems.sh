#!/bin/sh

# This script attempts to create a set of user-installed gems that can be safely copied
# to production servers for an enhanced experience
GEM_NAME=.gem
GEM_DIR=~/.gem
GEM_BACKUP_DIR=~/.gem.backup
RUBY_DIR='/usr/local/ruby/bin'
LOCAL_GEMS_PACKAGE=local_gems_package.tar.bz2

# If there is an existing .gem directory, back it up
function backup_gem_dir {
    echo "Backing up the gem directory"
    # Remove any already existing .gem.backup directory
    if [ -d $GEM_BACKUP_DIR ]
    then
	echo "Removing $GEM_BACKUP_DIR"
	rm -fr $GEM_BACKUP_DIR
    fi
    # Now, rename the .gem directory to the backup directory
    if [ -d $GEM_DIR ]
    then
	echo "Renaming $GEM_DIR to $GEM_BACKUP_DIR"
	mv $GEM_DIR $GEM_BACKUP_DIR
    fi
}

function replace_gem_dir {
    echo "Replacing the gem directory"
    if [ ! -d $GEM_BACKUP_DIR ]
    then
	echo "There is no $GEM_BACKUP_DIR!. Are you sure you know what you're doing?"
	exit 1
    fi
    # Fine, go ahead and remove the .gem directory
    if [ -d $GEM_DIR ]
    then
	echo "Removing the $GEM_DIR"
	rm -fr $GEM_DIR
    fi

    # Then, rename the backup directory
    echo "Renaming the backup directory"
    mv $GEM_BACKUP_DIR $GEM_DIR
}

function show_help {
    echo "Usage: $0 [-r ruby-interpreter -h] gems_to_load"
    echo "Where:"
    echo "  -r ruby-interpreter  Specify the ruby to use (e.g. ruby-1.9.2@-p327)"
    echo "  -h                   Display this help"
    echo
}

function install_gems {
    local gem_list_file=$1

    for gem in $(cat $gem_list_file)
    do
	${RUBY_DIR}/gem install --user-install ${gem} --no-ri --no-rdoc
    done
}

function package_local_gems {
    if [ -e $LOCAL_GEMS_PACKAGE ]
    then
	rm $LOCAL_GEMS_PACKAGE
    fi
    
    cd ~; tar jcf $LOCAL_GEMS_PACKAGE $GEM_NAME
}

while getopts "hr:" opt
do
    case "$opt" in
	h)
	    show_help
	    exit 0
	    ;;
	r)
	    RUBY_DIR=/usr/local/${OPTARG}/bin
	    ;;
    esac
done

shift $((OPTIND-1))

echo "Number of command line arguments: $#"
echo "Ruby directory: $RUBY_DIR"

if [ $# -ne 1 ]
then
    echo "You must specify the name of the file containing the list of gems to load"
    exit 1
fi

GEM_LIST_FILE=$1

if [ ! -e "$GEM_LIST_FILE" ]
then
    echo "The specified gem list file ($GEM_LIST_FILE) does not exist!"
    exit 1
fi

if [ ! -z '$RUBY_DIR' ]
then
    # Make sure the specified ruby actually exists
    if [ ! -d $RUBY_DIR ]
    then
	echo "The specified ruby directory doesn't exist: $RUBY_DIR"
	exit 1
    fi
fi

# OK, we've gathered up all the stuff from the command line and
# verified it, I guess we can get going now...

backup_gem_dir

install_gems $GEM_LIST_FILE

package_local_gems

replace_gem_dir