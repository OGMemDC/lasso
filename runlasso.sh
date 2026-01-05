#!/usr/bin/env bash
if [ -f "/etc/lasso/bootstrap" ] ; then 
	echo "checking last bootstrapped timestamp..."
fi
echo "launching lasso..."
python3 ./app.py
