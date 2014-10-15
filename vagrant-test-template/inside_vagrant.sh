#!/bin/bash
set -e

echo -n "$(date '+%F %T') Started " > /vagrant/progress.txt

# Install software prerequisites
echo -n "$(date '+%F %T') apt-get.. " >> /vagrant/progress.txt
sudo apt-get install -q -y git
echo "ok"             >> /vagrant/progress.txt

# Install and run devstack
echo -n "$(date '+%F %T') devstack.. " >> /vagrant/progress.txt
cd $HOME
git clone https://github.com/virtualopensystems/devstack.git
cd devstack
cp /vagrant/local.conf .
./stack.sh
echo "ok" >> /vagrant/progress.txt

# Install and run tempest
echo -n "$(date '+%F %T') tempest.. " >> /vagrant/progress.txt
cd /opt/stack/tempest
testr init
testr run tempest.api.network | tee -a /vagrant/tempest.log

#Searching for test IDs
x=$(grep "(id=" /vagrant/tempest.log)
#removing parenthesis
y="${x//[()=]/ }"

TEST_ID=$(echo ${y} | awk '{print $3}' | sed 's/\,//g')

echo "List of tempest tests successfully ran (id="${TEST_ID}"):" >> /vagrant/tempest_test_list.txt
grep -ri successful .testrepository/${TEST_ID} | awk '{ gsub(/\[/, "\ "); print $1 " " $2}' >> /vagrant/tempest_test_list.txt

if grep PASSED /vagrant/tempest.log; then
    echo "SUCCESS" >> /vagrant/progress.txt
else
    echo "FAILURE" >> /vagrant/progress.txt
fi

# That's it
echo "$(date '+%F %T') Finished" >> /vagrant/progress.txt
