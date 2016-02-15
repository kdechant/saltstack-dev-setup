# saltstack-dev-setup
SaltStack configuration for setting up a Linux dev machine for web development

## Usage (Ubuntu/Mint)
`sudo apt-get install git salt-master salt-minion`
`git clone {{this repo}}`
`sudo ln -s ~/saltstack-dev-setup/ /srv/salt`
`sudo nano /etc/salt/minion` and change the ID to your username
`sudo salt-call --local state.highstate`

The command will take a few minutes to complete.

