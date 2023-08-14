#!/bin/bash
## Usage: one4all.sh <JAR/WAR FILE>

HELP_MSG="Usage: $0 <WAR FILE | JAR FILE> [-v]"

# Check for user input
if [ -z "$1" ]; then
    echo -e "$HELP_MSG\nError: Please provide the WAR/jar file name as an argument"
    exit 1
fi

# Check if file provided exists!
if [ ! -f $1 ]; then
    echo -e "$HELP_MSG\nError: File $1 not found!"
    exit 1
fi

# Print obligatory ASCII banner
echo ""
echo "   _ \   \ |  __|    __| _ \  _ \      \    |     |    "
echo "  (   | .  |  _|     _| (   |   /     _ \   |     |    "
echo " \___/ _|\_| ___|   _| \___/ _|_\   _/  _\ ____| ____| "

# Init vars
O_DIR=$(pwd)
CLASS_DIR="CLASSES"
OUT_JAR="all.jar"

# Create temp dir
mkdir /tmp/$CLASS_DIR
unzip -q -d /tmp/$CLASS_DIR $1
cd /tmp/$CLASS_DIR

# Find all class resources
echo -e "\n[+] Searching for resources..."
while [ -n "$(find . -type f -name '*.jar' -print -quit)" ]; do 
    find . -name "*.jar" -exec unzip -q -o {} \; -exec sh -c 'echo "  Processing {}..." && rm {}' \;
done
find . -type d -name "classes" -exec sh -c 'echo "  Processing {}..." && cp -r {}/. .' \; -exec rm -rf {} \; 2>/dev/null
find . -type f -not -name "*.class" -not -name "*.xml" -not -name "*.properties" -exec rm {} \;
find . -type d -empty -delete

# Output jar structure if verbose flag  set
if [[ $# -ge 2 && "$2" == "-v" ]]; then
    echo -e "\n[+] Jar Structure"
    echo "$(tree -L 2 | head -n -1)"
fi

# Create jar
echo -e "\n[+] Creating jar\n  $O_DIR/$OUT_JAR\n"
jar -cf $O_DIR/$OUT_JAR *

# Cleanup
cd $O_DIR
rm -rf /tmp/$CLASS_DIR
