#!/usr/bin/env bash

apt update

# NOTE: prefect requires python3

## install python3 on amazon linux 2
#sudo amazon-linux-extras enable python3.8
#sudo yum install python3.8 -y

## on ubuntu 20.04, python3 is already installed.

## make python3 the default python on amazon linux 2
#sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1


# install python 3.9 and make it the python3 preferred installation
apt install python3.9
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2

## make python3 the default python on ubuntu
apt install python-is-python3 -y
export PATH="$(python -m site --user-site):${PATH}"

# check python version
python --version

# install pip on amazon linux 2
#curl -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py

# install pip3 in Ubuntu
apt install python3-pip -y

# sqlite3
# note: sqlite3 appears to be installed by default on amazon-linux-2
# install sqlite3 on ubuntu
apt install sqlite3 -y
sqlite3 --version

# install prefect and supervisor
pip install prefect
export PATH="/home/ubuntu/.local/bin:${PATH}"

# install supervisor
# - note using the distribution version because it is acceptably recent
#   and provides the integration into systemd
# - service config is placed at /usr/lib/systemd/system/supervisor.service
# - use option here to avoid overwriting the conf file
#   that is already in place at /etc/supervisor/supervisord.conf
apt-get install -o Dpkg::Options::="--force-confold" supervisor

#prefect orion start > orion.log 2>&1 &
#prefect agent start -t default > prefect-agent.log 2>&1 &
#prefect work-queue create -t ubuntu ubuntu
