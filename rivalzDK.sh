#!/bin/bash

# ----------------------------
# Color and Icon Definitions
# ----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"

# ----------------------------
# Function to display ASCII logo and Telegram link
# ----------------------------
display_ascii() {
    clear
    echo -e "    ${RED}    ____  __ __    _   ______  ____  ___________${RESET}"
    echo -e "    ${GREEN}   / __ \\/ //_/   / | / / __ \\/ __ \\/ ____/ ___/${RESET}"
    echo -e "    ${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${RESET}"
    echo -e "    ${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${RESET}"
    echo -e "    ${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${RESET}"
    echo -e "    ${MAGENTA}🚀 Follow us on Telegram: https://t.me/dknodes${RESET}"
    echo -e "    ${MAGENTA}📢 Follow us on Twitter: https://x.com/dknodes${RESET}"
    echo -e ""
    echo -e "    ${GREEN}Welcome to the Rivalz Node Installation Wizard!${RESET}"
    echo -e ""
}

# ----------------------------
# Install Docker and Docker Compose
# ----------------------------
install_docker() {
    echo -e "${INSTALL} Installing Docker and Docker Compose...${RESET}"
    sudo apt update && sudo apt upgrade -y
    if ! command -v docker &> /dev/null; then
        sudo apt install docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo -e "${CHECKMARK} Docker and Docker Compose installed successfully.${RESET}"
}

# ----------------------------
# Install the Rivalz Node
# ----------------------------
install_node() {
    echo -e "${INSTALL} Installing Rivalz Node...${RESET}"
    install_docker

    # Prompt for environment variables
    echo -e "${INFO} Please provide the following configuration details:${RESET}"
    read -p "Enter your WALLET_ADDRESS: " WALLET_ADDRESS
    read -p "Enter the number of CPU_CORES: " CPU_CORES
    read -p "Enter the amount of RAM (e.g., 4G): " RAM
    read -p "Enter the DISK_SIZE (e.g., 10G): " DISK_SIZE

    # Create .env file
    cat > .env <<EOL
WALLET_ADDRESS=${WALLET_ADDRESS}
CPU_CORES=${CPU_CORES}
RAM=${RAM}
DISK_SIZE=${DISK_SIZE}
EOL

    echo -e "${CHECKMARK} .env file created with your configurations.${RESET}"

    # Check for docker-compose.yml
    if [ ! -f docker-compose.yml ]; then
        echo -e "${ERROR} docker-compose.yml file not found. Please ensure it is in the current directory.${RESET}"
        exit 1
    fi

    # Build and run containers
    docker-compose up -d --build
    echo -e "${CHECKMARK} Rivalz Node installed and running.${RESET}"
    read -p "Press enter to return to the main menu..."
}

# ----------------------------
# Stop the Rivalz Node
# ----------------------------
stop_node() {
    echo -e "${STOP} Stopping Rivalz Node...${RESET}"
    docker-compose down
    echo -e "${CHECKMARK} Rivalz Node stopped.${RESET}"
    read -p "Press enter to return to the main menu..."
}

# ----------------------------
# Restart the Rivalz Node
# ----------------------------
restart_node() {
    echo -e "${RESTART} Restarting Rivalz Node...${RESET}"
    docker-compose down
    docker-compose up -d
    echo -e "${CHECKMARK} Rivalz Node restarted successfully.${RESET}"
    read -p "Press enter to return to the main menu..."
}

# ----------------------------
# View Rivalz Node Logs
# ----------------------------
view_logs() {
    echo -e "${LOGS} Viewing last 30 logs of Rivalz Node...${RESET}"
    docker-compose logs --tail 30
#    echo -e "${LOGS} Streaming logs in real-time... Press Ctrl+C to stop.${RESET}"
#    docker-compose logs -f
    read -p "Press enter to return to the main menu..."
}

# ----------------------------
# Display Node ID and .env Data
# ----------------------------
display_id_env() {
    echo -e "${INFO} Displaying Node ID and Configuration Data...${RESET}"
    echo -e "${GREEN}ℹ️  Node ID:${RESET}"
    cat /etc/machine-id
    echo -e "${GREEN}\nℹ️  .env Configuration:${RESET}"
    if [ -f .env ]; then
        cat .env
    else
        echo -e "${ERROR} .env file not found.${RESET}"
    fi
    read -p "Press enter to return to the main menu..."
}

# ----------------------------
# Draw Menu Borders
# ----------------------------
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}"
}

draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${RESET}"
}

draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}"
}

# ----------------------------
# Main Menu
# ----------------------------
show_menu() {
    clear
    display_ascii
    draw_top_border
    echo -e "    ${YELLOW}Choose an option:${RESET}"
    draw_middle_border
    echo -e "    ${CYAN}1.${RESET} ${INSTALL} Install Rivalz Node"
    echo -e "    ${CYAN}2.${RESET} ${INFO} View Node ID and Configuration"
    echo -e "    ${CYAN}3.${RESET} ${STOP} Stop Rivalz Node"
    echo -e "    ${CYAN}4.${RESET} ${RESTART} Restart Rivalz Node"
    echo -e "    ${CYAN}5.${RESET} ${LOGS} View Rivalz Node Logs"
    echo -e "    ${CYAN}6.${RESET} ${EXIT} Exit"
    draw_bottom_border
    echo -ne "${YELLOW}Enter your choice [1-6]: ${RESET}"
}

# ----------------------------
# Main Loop
# ----------------------------
while true; do
    show_menu
    read -r choice
    case $choice in
        1)
            install_node
            ;;
        2)
            display_id_env
            ;;
        3)
            stop_node
            ;;
        4)
            restart_node
            ;;
        5)
            view_logs
            ;;
        6)
            echo -e "${EXIT} Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ERROR} Invalid option. Please try again.${RESET}"
            read -p "Press enter to continue..."
            ;;
    esac
done
