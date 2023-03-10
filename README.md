# Docker Installation Script

This script installs Docker and Docker Compose on Ubuntu 22.04 using `apt-get`, and allows the user to add a user to the `docker` group to enable running Docker commands without using `sudo`.

## Prerequisites

- Ubuntu 22.04
- `apt-get` package manager
- `curl` command-line tool
- `sudo` privileges

## Installation

1. Clone the repository to your local machine:

`git clone https://github.com/smashingtags/hcint.git`

2. Change directory to the cloned repository:

`cd hcint`

3. Make the script executable:

`chmod +x install.sh`


4. Run the script with `sudo`:

`sudo ./install.sh`


5. Follow the prompts to install Docker and Docker Compose, and add a user to the `docker` group.

## Usage

To run the script, use the command:

`sudo ./install.sh`


When prompted, choose an option from the menu:

- `1` Install Docker and Docker Compose
- `2` Add a user to the `docker` group
- `3` Exit the script

If you choose to add a user to the `docker` group, you will be prompted to enter a username. Enter the username and press enter. The script will add the user to the `docker` group and display a message to log out and log back in for the changes to take effect.

## Contributing

If you find a bug or have an improvement suggestion, feel free to open an issue or submit a pull request. 

## License

This script is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
