#!/bin/bash
SD_CARD=/media/seb/FC30-3DA9/
SOC_FILE=soc.rbf
CORE_FILE=core.rbf
FW_FILE=fw/sd8.rom
ROM_FILE=sd8.rom

if [ -d "$SD_CARD" ]; then
    echo "SD_CARD found"

    if [ -f $SOC_FILE ]; then
        echo "Deploying CORE"
        cp $SOC_FILE $SD_CARD/$CORE_FILE
    fi

    if [ -f $FW_FILE ]; then
        echo "Deploying ROM"
        cp $FW_FILE $SD_CARD/$ROM_FILE
    fi

fi
