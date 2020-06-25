#!/usr/bin/env bash

## Check if user is executing script from root directory

if ! [[ ${0} == './execute_this.sh' ]]
then
        echo -e '\n\033[1;31m[ERR]: Please execute this script from root directory of repository\033[0m\n'
	exit 1
fi

## Warn user of package installation

echo -e '\n\033[0;33m[WARNING]:\n\n   GOING TO INSTALL PACKAGES\n\n\tvagrant\n\tvirtualbox\n\tansible\033[0m\n'

read -n1 -p 'Do you want to continue [Y/n]' response ; tput cr ; tput el

if ! grep -iq '^y' <<<"${response:-y}"
then
	echo 'Exiting'
	exit 2
fi

sudo apt-get install -y vagrant virtualbox ansible curl sed

if sudo ss -nltpua | grep :8000
then
	echo Port 8000 is already occupied, please make sure it is available
fi

cd vagrant

vagrant init ubuntu/bionic64

## Add port forwarding and provisioning information in Vagrantfile

sed -i '/config.vm.box = "ubuntu\/bionic64"/a\\n  config.vm.network "forwarded_port", guest: 8000, host: 8000\n\n  config.vm.provision "ansible" do |ansible|\n    ansible.playbook = "ansible/playbook.yml"\n    ansible.verbose = true\n  end' Vagrantfile

vagrant up

## Present user of way to check and the output we got

echo -e 'To test, execute,\n\n\t\t curl 127.0.0.1:8000\n'

for i in {1..10}
do
        curl 127.0.0.1:8000 && echo
done
