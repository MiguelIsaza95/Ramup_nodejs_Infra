#!/bin/bash

# Configure environment for ansible local provision
pip3 install -r requierements.txt --upgrade
chmod +x ec2.py
export EC2_INI_PATH=./ec2.ini
export ANSIBLE_INVENTORY=./ec2.py

# Run playbook
ansible-playbook -i ec2.py playbook.yml --limit "tag_Name_jenkins:&tag_Environment_Test"
