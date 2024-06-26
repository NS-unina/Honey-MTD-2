#!/bin/sh

sudo apt update
sudo apt -y install systemd
sudo apt -y install telnetd
sudo ufw allow 23/tcp
sudo useradd host
sudo passwd host

sudo apt -y install vsftpd
sudo service vsftpd enable
sudo service vsftpd start

sudo apt -y install apache2
sudo service apache2 enable
sudo service apache2 start

# vedi servizio vulnerabile da installare
#vuln sudoedit
sudo apt install -y --allow-downgrades sudo=1.8.31-1ubuntu1
echo "administrator ALL = (ALL) ALL" | sudo tee -a /etc/sudoers
echo "administrator ALL = (root) NOPASSWD: /usr/bin/sudoedit" | sudo tee -a /etc/sudoers

#auditbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.7.0-amd64.deb
sudo dpkg -i auditbeat-8.7.0-amd64.deb

sudo cp /home/claudio/ubuntu/int_service/auditbeat.yml /etc/auditbeat/auditbeat.yml
sudo service auditbeat start
sudo systemctl enable auditbeat
