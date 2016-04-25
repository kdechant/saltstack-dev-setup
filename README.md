# saltstack-dev-setup
SaltStack configuration for setting up a Linux dev machine for web development

## Usage (Ubuntu/Mint)
```
sudo apt-get install git salt-master salt-minion

git clone https://github.com/kdechant/saltstack-dev-setup.git

sudo ln -s ~/saltstack-dev-setup/ /srv/salt

sudo nano /etc/salt/minion
# in nano, change the minion ID to your username

sudo salt-call --local state.highstate
```

The command will take a few minutes to complete.

Errors may happen. This is alpha-quality software and it may encounter trouble with different Linux versions and with software already installed on the system. It currently works best with Ubuntu 14.04 or Linux Mint 17.x and has partial support for Fedora Core 23. Your mileage may vary.

