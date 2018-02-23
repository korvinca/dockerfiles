#!/bin/bash

create_user() {
# Create a user to SSH into as.
useradd -ms /bin/bash -G sudo user
SSH_USERPASS="password"
echo "user:$SSH_USERPASS" | chpasswd
echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
}

# Call all functions
create_user