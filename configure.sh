#!/bin/sh
PYTHON=python3
$PYTHON -m venv ./venv
source ./venv/bin/activate
$PYTHON -m pip install -r requirements.txt
deactivate
