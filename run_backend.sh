#!/usr/bin/env bash
set -e
cd backend
python3.11 -m venv venv 2>/dev/null || true
source venv/bin/activate
pip install -r requirements.txt
python app.py
