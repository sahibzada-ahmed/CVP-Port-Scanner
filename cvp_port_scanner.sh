#!/bin/bash

# Function to print messages in red or green randomly
print_message() {
    local message=$1
    local color=$((RANDOM % 2))
    if [[ $color -eq 0 ]]; then
        echo -e "\033[0;31m$message\033[0m" # Red
    else
        echo -e "\033[0;32m$message\033[0m" # Green
    fi
}

# Display the header
print_message "CVP Port Scanner"
print_message "Developed by Faraz Ahmed"
echo
print_message "Join our WhatsApp Channel: https://whatsapp.com/channel/0029Vah0DdcIyPtafachzG3B"
echo

# Prompt user for IP address
read -p "Enter IP address to scan: " IP

# Validate input
if [[ -z "$IP" ]]; then
    print_message "No IP address provided. Exiting."
    exit 1
fi

print_message "Scanning IP: $IP"
echo "----------------"

# Define port information with detailed explanations
declare -A PORT_INFO
PORT_INFO[22]="SSH (Port 22): Used for secure remote access to servers."
PORT_INFO[80]="HTTP (Port 80): Indicates that a web server is running."
PORT_INFO[443]="HTTPS (Port 443): Indicates a secure web server is running."
PORT_INFO[21]="FTP (Port 21): Used for file transfer. Ensure that anonymous access is disabled."
PORT_INFO[25]="SMTP (Port 25): Used for sending emails. Exposed SMTP can be abused for spam."
PORT_INFO[3306]="MySQL (Port 3306): Indicates a MySQL database is running."
PORT_INFO[5432]="PostgreSQL (Port 5432): Indicates a PostgreSQL database is running."
PORT_INFO[3389]="RDP (Port 3389): Used for remote desktop connections. Ensure strong passwords and consider using Network Level Authentication."
PORT_INFO[6379]="Redis (Port 6379): Indicates a Redis database is running."
PORT_INFO[27017]="MongoDB (Port 27017): Indicates a MongoDB database is running."

# Function to scan a port
scan_port() {
    local port=$1
    timeout 1 bash -c "echo > /dev/tcp/$IP/$port" 2>/dev/null && {
        print_message "Port $port is open"
        if [[ -n "${PORT_INFO[$port]}" ]]; then
            print_message "  Details: ${PORT_INFO[$port]}"
        else
            print_message "  Details: Service information not available."
        fi
    } || {
        print_message "Port $port is closed or filtered"
    }
}

# Read specific ports to scan (comma-separated)
read -p "Enter the specific ports to scan (comma-separated, or leave blank to scan all ports from 1 to 1024): " PORTS

print_message "Scanning in process..."

if [[ -z "$PORTS" ]]; then
    # If no specific ports are provided, check port 80 first for website indication
    scan_port 80
    # Scan ports 1 to 1024
    for port in {1..1024}; do
        scan_port $port
    done
else
    # Convert comma-separated ports into an array and scan them
    IFS=',' read -r -a PORT_ARRAY <<< "$PORTS"
    for port in "${PORT_ARRAY[@]}"; do
        scan_port $port
    done
fi

print_message "Scanning completed by CVP Port Scanner"
