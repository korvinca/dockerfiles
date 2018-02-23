#!/bin/bash

create_user() {
# Create a user to SSH into as.
useradd user
usermod -aG wheel user
SSH_USERPASS="password"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin user)
echo ssh user password: $SSH_USERPASS
echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
}

# Call all functions
create_user