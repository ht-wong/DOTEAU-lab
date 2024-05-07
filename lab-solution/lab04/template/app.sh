#!/bin/bash
sudo yum install -y python3
sudo pip3 install flask 
kill  `cat app.pid`
sleep 1
nohup python3 /home/ec2-user/app.py > /dev/null 2>&1 & echo $! > /home/ec2-user/app.pid
sleep 3
curl localhost:8080
