#!/bin/sh

# apt-get install salt-master salt-minion -y

# set up local salt operations
echo -e "\nfile_client: local\n" >> /etc/salt/minion

# salt likes to have its formulas in /srv/salt. We'll symlink this to the git repo we just cloned.
ln -s ~/saltstack-dev-setup /srv/salt

# run the salt call
# if you run this line from outside this script you need sudo.
salt-call --local state.highstate

echo -e "Salt environment is set up. You can call the salt formula from the command line by typing 'sudo salt-call --local state.highstate'"


