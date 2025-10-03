#!/bin/bash

# Configuration
TERMILITY_NAME="Termility NG"
TERMILITY_VERSION="2.0"
AUTHOR="Koushik Pal (KP)"
WEBSITE="https://www.kalilinux.in"
CONFIG_DIR="$HOME/.config/termility"
LOG_FILE="$CONFIG_DIR/termility.log"

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'

# Initialize configuration
init_config() {
    mkdir -p "$CONFIG_DIR"
    touch "$LOG_FILE"
}

# Logging function
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Display header
show_header() {
    clear
    echo -e "${CYAN}###############################################${RESET}"
    if command -v toilet &> /dev/null; then
        toilet -f smblock --filter border:metal "Termility NG"
    else
        echo -e "${BOLD}${GREEN}Termility NG - Next Generation Terminal Utility${RESET}"
    fi
    echo -e "${CYAN}###############################################${RESET}"
    echo -e "${BOLD}${RED}############# $AUTHOR ############${RESET}"
    echo -e "${CYAN}###############################################${RESET}"
    echo -e "${GREEN}Version: $TERMILITY_VERSION${RESET}"
    echo -e "${YELLOW}Please Visit: $WEBSITE${RESET}"
    echo ""
}

# Check dependencies
check_dependencies() {
    local deps=("curl" "wget")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${YELLOW}Installing missing dependencies...${RESET}"
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y "${missing[@]}"
        elif command -v yum &> /dev/null; then
            sudo yum install -y "${missing[@]}"
        elif command -v brew &> /dev/null; then
            brew install "${missing[@]}"
        fi
    fi
}

# Weather function
check_weather() {
    echo -e "${BOLD}${UNDERLINE}Weather Check${RESET}"
    echo ""
    echo -e "${YELLOW}Please use portrait or fullscreen mode for better results.${RESET}"
    echo ""
    echo -e "${CYAN}Enter city name (or leave blank for auto-detection):${RESET}"
    read -r LOC
    
    if [ -z "$LOC" ]; then
        echo -e "${YELLOW}Detecting location based on IP...${RESET}"
        curl -s "wttr.in?format=%l" | read -r detected_loc
        echo -e "${GREEN}Detected location: $detected_loc${RESET}"
        LOC="$detected_loc"
    fi
    
    echo -e "${CYAN}Fetching weather information...${RESET}"
    curl -s "wttr.in/$LOC"
    log_action "Checked weather for: $LOC"
}

# IP information function
check_external_ip() {
    echo -e "${BOLD}${UNDERLINE}External IP Information${RESET}"
    echo ""
    echo -e "${CYAN}Fetching IP information...${RESET}"
    curl -s "ipinfo.io" | jq '.' 2>/dev/null || curl -s "ipinfo.io"
    log_action "Checked external IP information"
}

# File upload function
upload_file() {
    echo -e "${BOLD}${UNDERLINE}File Upload${RESET}"
    echo ""
    echo -e "${YELLOW}Blocked files: applications, executables, Android APKs, and system images${RESET}"
    echo -e "${YELLOW}Max size: 512MiB${RESET}"
    echo ""
    echo -e "${CYAN}Enter file path:${RESET}"
    read -r path
    
    if [ ! -f "$path" ]; then
        echo -e "${RED}Error: File not found!${RESET}"
        return 1
    fi
    
    echo -e "${CYAN}Uploading file...${RESET}"
    response=$(curl -s -F'file=@'"$path" "http://0x0.st")
    echo -e "${GREEN}Upload successful!${RESET}"
    echo -e "${BLUE}Download URL: $response${RESET}"
    echo -e "${YELLOW}File URLs are valid for at least 30 days.${RESET}"
    log_action "Uploaded file: $path - URL: $response"
}

# URL shortener function
url_shortener() {
    echo -e "${BOLD}${UNDERLINE}URL Shortener${RESET}"
    echo ""
    echo -e "${CYAN}Paste your long URL:${RESET}"
    read -r longurl
    
    if [[ ! "$longurl" =~ ^https?:// ]]; then
        longurl="https://$longurl"
    fi
    
    echo -e "${CYAN}Shortening URL...${RESET}"
    short=$(curl -s "https://is.gd/create.php?format=simple&url=${longurl}")
    echo -e "${GREEN}URL shortened successfully!${RESET}"
    echo -e "${BLUE}Short URL: $short${RESET}"
    log_action "Shortened URL: $longurl -> $short"
}

# URL expander function
expand_url() {
    echo -e "${BOLD}${UNDERLINE}URL Expander${RESET}"
    echo ""
    echo -e "${CYAN}Paste your short URL:${RESET}"
    read -r url
    
    echo -e "${CYAN}Expanding URL...${RESET}"
    expanded=$(curl -s -I -L -w "%{url_effective}" -o /dev/null "$url")
    echo -e "${GREEN}Original URL:${RESET}"
    echo -e "${BLUE}$expanded${RESET}"
    log_action "Expanded URL: $url -> $expanded"
}

# Media download function
download_media() {
    echo -e "${BOLD}${UNDERLINE}Media Downloader${RESET}"
    echo ""
    
    if command -v yt-dlp &> /dev/null; then
        echo -e "${GREEN}yt-dlp is available${RESET}"
        downloader="yt-dlp"
    elif command -v youtube-dl &> /dev/null; then
        echo -e "${YELLOW}youtube-dl is available (consider installing yt-dlp)${RESET}"
        downloader="youtube-dl"
    else
        echo -e "${YELLOW}Installing yt-dlp...${RESET}"
        if command -v pip3 &> /dev/null; then
            pip3 install yt-dlp
        elif command -v pip &> /dev/null; then
            pip install yt-dlp
        else
            echo -e "${RED}Error: pip not available. Please install yt-dlp manually.${RESET}"
            return 1
        fi
        downloader="yt-dlp"
    fi
    
    echo -e "${CYAN}Paste video URL:${RESET}"
    read -r url
    
    echo -e "${CYAN}Select quality:${RESET}"
    echo "1. Best quality (default)"
    echo "2. 720p"
    echo "3. 480p"
    echo "4. Audio only"
    read -r quality_choice
    
    case $quality_choice in
        2) quality="-f 'best[height<=720]'" ;;
        3) quality="-f 'best[height<=480]'" ;;
        4) quality="-f 'bestaudio/best'" ;;
        *) quality="" ;;
    esac
    
    echo -e "${CYAN}Downloading...${RESET}"
    eval "$downloader $quality \"$url\""
    log_action "Downloaded media from: $url"
}

# System monitor function
system_monitor() {
    echo -e "${BOLD}${UNDERLINE}System Monitor${RESET}"
    echo ""
    
    if command -v btop &> /dev/null; then
        echo -e "${GREEN}Starting btop (advanced system monitor)...${RESET}"
        btop
    elif command -v htop &> /dev/null; then
        echo -e "${GREEN}Starting htop...${RESET}"
        htop
    else
        echo -e "${YELLOW}Installing system monitor...${RESET}"
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y htop
            htop
        else
            echo -e "${RED}System monitor not available.${RESET}"
        fi
    fi
    log_action "Started system monitor"
}

# Network tools function
network_tools() {
    while true; do
        clear
        echo -e "${BOLD}${UNDERLINE}Network Tools${RESET}"
        echo ""
        echo "1. Ping host"
        echo "2. Traceroute"
        echo "3. Port scan"
        echo "4. Network speed test"
        echo "5. Back to main menu"
        echo ""
        echo -e "${CYAN}Select option:${RESET}"
        read -r net_choice
        
        case $net_choice in
            1)
                echo -e "${CYAN}Enter host to ping:${RESET}"
                read -r host
                ping -c 5 "$host"
                ;;
            2)
                echo -e "${CYAN}Enter host for traceroute:${RESET}"
                read -r host
                traceroute "$host" 2>/dev/null || echo "traceroute not available"
                ;;
            3)
                echo -e "${CYAN}Enter host for port scan:${RESET}"
                read -r host
                if command -v nc &> /dev/null; then
                    for port in {1,21,22,23,53,80,443,8080}; do
                        nc -zv "$host" "$port" 2>&1 | grep succeeded
                    done
                else
                    echo "netcat not available"
                fi
                ;;
            4)
                if command -v speedtest-cli &> /dev/null; then
                    speedtest-cli
                else
                    echo "Install speedtest-cli for this feature"
                fi
                ;;
            5) return ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
        echo ""
        echo -e "${CYAN}Press Enter to continue...${RESET}"
        read -r
    done
}

# Security tools function
security_tools() {
    while true; do
        clear
        echo -e "${BOLD}${UNDERLINE}Security Tools${RESET}"
        echo ""
        echo "1. Generate secure password"
        echo "2. Check password hash"
        echo "3. SSL certificate check"
        echo "4. Back to main menu"
        echo ""
        echo -e "${CYAN}Select option:${RESET}"
        read -r sec_choice
        
        case $sec_choice in
            1)
                length=16
                password=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9!@#$%^&*' | head -c "$length")
                echo -e "${GREEN}Generated password: $password${RESET}"
                ;;
            2)
                echo -e "${CYAN}Enter string to hash:${RESET}"
                read -r text
                echo -e "${GREEN}MD5: $(echo -n "$text" | md5sum | cut -d' ' -f1)${RESET}"
                echo -e "${GREEN}SHA256: $(echo -n "$text" | sha256sum | cut -d' ' -f1)${RESET}"
                ;;
            3)
                echo -e "${CYAN}Enter domain:${RESET}"
                read -r domain
                openssl s_client -connect "$domain:443" -servername "$domain" < /dev/null 2>/dev/null | openssl x509 -noout -dates
                ;;
            4) return ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
        echo ""
        echo -e "${CYAN}Press Enter to continue...${RESET}"
        read -r
    done
}

# Main menu
main_menu() {
    while true; do
        show_header
        echo -e "${BOLD}${UNDERLINE}Please select an option:${RESET}"
        echo ""
        echo -e "${RED}1. Check Weather${RESET}"
        echo -e "${GREEN}2. External IP Information${RESET}"
        echo -e "${YELLOW}3. File Upload${RESET}"
        echo -e "${PURPLE}4. URL Shortener${RESET}"
        echo -e "${PURPLE}5. Expand Short URL${RESET}"
        echo -e "${CYAN}6. Download Videos${RESET}"
        echo -e "${BLUE}7. System Monitor${RESET}"
        echo -e "${BLUE}8. Network Tools${RESET}"
        echo -e "${BLUE}9. Security Tools${RESET}"
        echo -e "${GREEN}10. Watch Star Wars (ASCII)${RESET}"
        echo -e "${WHITE}11. Exit${RESET}"
        echo ""
        echo -e "${CYAN}Enter your choice (1-11):${RESET}"
        read -r OPT
        
        case $OPT in
            1) check_weather ;;
            2) check_external_ip ;;
            3) upload_file ;;
            4) url_shortener ;;
            5) expand_url ;;
            6) download_media ;;
            7) system_monitor ;;
            8) network_tools ;;
            9) security_tools ;;
            10)
                echo -e "${CYAN}Starting Star Wars ASCII animation...${RESET}"
                echo -e "${YELLOW}Press Ctrl+] then type 'quit' to exit${RESET}"
                sleep 3
                telnet towel.blinkenlights.nl
                ;;
            11)
                echo -e "${GREEN}Thank you for using Termility NG!${RESET}"
                echo ""
                echo -e "${CYAN}Made by $AUTHOR${RESET}"
                echo -e "${YELLOW}$WEBSITE${RESET}"
                log_action "Termility session ended"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${RESET}"
                sleep 2
                ;;
        esac
        
        echo ""
        echo -e "${CYAN}Press Enter to continue...${RESET}"
        read -r
    done
}

# Main execution
init_config
check_dependencies
main_menu
