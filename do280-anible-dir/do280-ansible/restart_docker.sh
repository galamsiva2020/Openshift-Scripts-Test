#!/bin/sh

cd /home/student/do280-ansible

sudo -u student ansible nodes -m service -a "name=docker state=restarted"

cd -

