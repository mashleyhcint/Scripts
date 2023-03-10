#!/bin/bash

# Function to display the menu
show_menu() {
    echo "Please select an option:"
    echo "1. Install SSH"
    echo "2. Add sudo user"
    echo "3. Add SFTP user"
    echo "4. Install Docker and Docker Compose"
    echo "5. Disable SELinux"
    echo "6. Check installed version of Docker"
    echo "7. Uninstall Docker and Docker Compose"
    echo "8. Install Portainer"
    echo "9. Add user's private key for SSH"
    echo "10. Install Apache"
    echo "11. Install PostgreSQL"
    echo "12. Install Zabbix agent"
    echo "13. Install Figlet Docker"
    echo "14. Set Firewall Rules For Apache 80/443"
    echo "0. Exit"
}

# Function to install SSH
install_ssh() {
    echo "Installing SSH..."
    sudo dnf install -y openssh-server
    sudo systemctl start sshd
    sudo systemctl enable sshd
    echo "SSH installed and started."
}

# Function to add sudo user
add_sudo_user() {
    echo "Please enter the username for the new sudo user:"
    read username
    sudo useradd -m -s /bin/bash $username
    sudo passwd $username
    sudo usermod -aG wheel $username
    echo "User $username added to sudo group."
}

# Function to add SFTP user
add_sftp_user() {
    echo "Please enter the username for the new SFTP user:"
    read username
    sudo useradd -m -s /bin/false $username
    sudo passwd $username
    sudo usermod -aG sftp $username
    sudo chown root:root /home/$username
    sudo chmod 755 /home/$username
    sudo mkdir /home/$username/files
    sudo chown $username:$username /home/$username/files
    echo "User $username added for SFTP."
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Installing Docker and Docker Compose..."
    sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker and Docker Compose installed and started."
}

# Function to disable SELinux
disable_selinux() {
    echo "Disabling SELinux..."
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    echo "SELinux disabled. Please reboot the system for the changes to take effect."
}

# Function to check installed version of Docker
check_docker_version() {
    echo "Checking installed version of Docker..."
    docker version
}

# Function to uninstall Docker and Docker Compose
uninstall_docker() {
    echo "Uninstalling Docker and Docker Compose..."
    sudo dnf remove -y docker-ce docker-ce-cli containerd.io
    sudo rm -f /usr/local/bin/docker-compose
    echo "Docker and Docker Compose uninstalled."
}

# Function to install Portainer
install_portainer() {
    echo "Installing Portainer..."
    sudo docker volume create portainer_data
    sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
    echo "Portainer installed and started."
}

# Function to add user's private key for SSH
add_ssh_key() {
    echo "Please enter the username for the user who's private key you want to add:"
    read username
    sudo mkdir /home/$username/.ssh
    sudo chmod 700 /home/$username/.ssh
    echo "Please paste the user's private key below (in one line):"
    read ssh_key
    sudo echo "$ssh_key" >> /home/$username/.ssh/authorized_keys
    sudo chmod 600 /home/$username/.ssh/authorized_keys
    sudo chown -R $username:$username /home/$username/.ssh
    echo "Private key added for user $username."
}

# Function to install Apache
install_apache() {
    echo "Installing Apache..."
    sudo dnf install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "Apache installed and started."
}

# Function to install PostgreSQL
install_postgresql() {
    echo "Installing PostgreSQL..."
    sudo dnf install -y postgresql-server postgresql-contrib
    sudo postgresql-setup --initdb
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    echo "PostgreSQL installed and started."
}

# Function to install Zabbix agent
install_zabbix_agent() {
    echo "Installing Zabbix agent..."
    sudo dnf install -y zabbix-agent
    sudo systemctl start zabbix-agent
    sudo systemctl enable zabbix-agent
    echo "Zabbix agent installed and started."
}

# Function to install figlet Docker image with alias figlet
install_figlet() {
    echo "Installing figlet Docker image..."
    sudo docker run -d --name figlet mwendler/figlet
    sudo echo "alias figlet='docker exec -it figlet figlet'" >> ~/.bashrc
    echo "figlet Docker image installed with alias figlet."
}

# Function to set firewall rules for http and https
set_firewall() {
    echo "Setting Firewall Rules..."
    sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
    sudo firewall-cmd --zone=public --permanent --add-port=443/tcp
    sudo firewall-cmd --reload
    echo "Firewall Rules Allowing 80 and 443 Set"
}

# Main loop
while true; do
    show_menu
    read -p "Enter option: " option
    case $option in
        1) install_ssh;;
        2) add_sudo_user;;
        3) add_sftp_user;;
        4) install_docker;;
        5) disable_selinux;;
        6) check_docker_version;;
        7) uninstall_docker;;
        8) install_portainer;;
        9) add_ssh_key;;
        10) install_apache;;
        11) install_postgresql;;
        12) install_zabbix_agent;;
        13) install_figlet;;
        14) set_firewall;;
        0) exit;;
        *) echo "Invalid option";;
    esac
    echo ""
done
