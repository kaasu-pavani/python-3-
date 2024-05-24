#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip git
git clone https://github.com/kaasu-pavani/car-prediction.git /home/ubuntu/car-prediction
cd /home/ubuntu/car-prediction
pip3 install -r requirements.txt
python3 app.py
screen -d python3 app.py
screen -d -m python3 app.py
~
