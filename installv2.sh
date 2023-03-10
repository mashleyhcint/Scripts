#!/bin/bash

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "dialog is not installed. Installing it now..."
    sudo apt-get update
    sudo apt-get install -y dialog
fi

# Show menu using dialog
while true; do
    choice=$(dialog --clear --stdout --title "Docker Installation Script" \
        --menu "Choose an option:" 11 50 5 \
        1 "Install Docker and Docker Compose" \
        2 "Add user to docker group" \
        3 "Uninstall Docker and Docker Compose" \
        4 "Check for existing Docker installation" \
        5 "Update Docker and Docker Compose" \
        6 "Install Portainer" \
        7 "Exit")

    case $choice in
        1)
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker.io

            # Install Docker Compose
            sudo curl -L "https://github.com/docker/compose/releases/download/$(curl --silent https://github.com/docker/compose/releases/latest | grep -oP 'tag/\K.*(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

            # Create directories for Docker
            sudo mkdir -p /var/lib/docker
            sudo mkdir -p /etc/docker

            # Restart Docker service
            sudo systemctl restart docker

            dialog --clear --title "Installation Complete" --msgbox "Docker and Docker Compose have been installed successfully!" 10 50
            ;;
        2)
            # Prompt user for username
            read -p "Enter username to add to docker group: " username

            # Add user to docker group
            sudo usermod -aG docker $username
            dialog --clear --title "User Added" --msgbox "User $username has been added to the docker group. Please log out and log back in for the changes to take effect." 10 50
            ;;
        3)
            # Uninstall Docker and Docker Compose
            sudo apt-get purge -y docker.io docker-compose
            sudo rm -rf /var/lib/docker
            sudo rm -rf /etc/docker

            dialog --clear --title "Uninstallation Complete" --msgbox "Docker and Docker Compose have been uninstalled successfully!" 10 50
            ;;
        4)
            # Check for existing Docker installation
            if ! command -v docker &> /dev/null; then
                dialog --clear --title "Docker not found" --msgbox "Docker is not installed on this system." 10 50
            else
                version=$(docker --version)
                dialog --clear --title "Docker found" --msgbox "Docker is installed on this system. $version" 10 50
            fi
            ;;
        5)
            # Update Docker and Docker Compose
            sudo apt-get update
            sudo apt-get upgrade -y docker.io
            sudo curl -L "https://github.com/docker/compose/releases/download/$(curl --silent https://github.com/docker/compose/releases/latest | grep -oP 'tag/\K.*(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

            dialog --clear --title "Update Complete" --msgbox "Docker and Docker Compose have been updated successfully!" 10 50
            ;;
        6)
            # Install Portainer
            sudo docker volume create portainer_data
            sudo docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

            dialog --clear --title "Installation Complete" --msgbox "Portainer has been installed successfully! Access it at http://localhost:9000" 10 50
            ;;
        7)
        # Exit
        break
        ;;
    *)
        # Invalid option
        dialog --clear --title "Invalid Option" --msgbox "Invalid option. Please choose an option between 1 and 3." 10 50
        ;;
esac
done
