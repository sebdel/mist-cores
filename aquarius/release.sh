#!/bin/bash
RBF_FILE=soc.rbf
if [ -f $RBF_FILE ]; then
	mv $RBF_FILE binaries/core_`date +"%y%m%d_%H%M%S"`.rbf
fi
