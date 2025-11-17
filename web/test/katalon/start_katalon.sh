#!/bin/bash

# Path to Java 17
JAVA17_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Path to Katalon executable
KATALON_PATH=~/Documents/Katalon_Studio_Enterprise_Linux_64-10.4.1/katalon

# Set Java environment variables
export JAVA_HOME=$JAVA17_HOME
export PATH=$JAVA_HOME/bin:$PATH

# Run Katalon
"$KATALON_PATH"

# chmod +x start_katalon.sh
