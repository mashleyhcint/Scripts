#HCINT_Docker_Install_Script
#Make Executable using "chmod +x install.sh"
#Execute with "sudo ./install.sh"
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
        --menu "Choose an option:" 10 50 3 \
        1 "Install Docker and Docker Compose" \
        2 "Add user to docker group" \
        3 "Exit")

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
            # Exit
            break
            ;;
        *)
            # Invalid option
            dialog --clear --title "Invalid Option" --msgbox "Invalid option. Please choose an option between 1 and 3." 10 50
            ;;
    esac
done
