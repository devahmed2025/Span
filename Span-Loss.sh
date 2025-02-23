#!/bin/bash

# Welcome message
echo -e "\nThis script was modified by Ahmed-Elshahhat to Calculate span-loss for Etisalat Network 2024 Version\n"
sleep 2
# Expiration date (YYYY-MM-DD)
EXPIRATION_DATE="2025-03-28"

# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Compare dates
if [[ "$CURRENT_DATE" > "$EXPIRATION_DATE" ]]; then
    echo "This script has expired. Please contact the administrator."
    exit 1
fi

# Get current date and time for the filename
timestamp=$(date +"%Y%m%d_%H_%M_%S")
csv_file="Amplifier_Power_Values_$timestamp.csv"
log_file="Amplifier_Power_Log_$timestamp.log"

# Prepare the CSV file
if [ ! -f "$csv_file" ]; then
    echo "device_name,interface,TX,RX" > "$csv_file"
fi

# Define devices with their IPs
declare -A devices=(
    ["ABR"]="10.74.58.126"
    ["TEL-01"]="10.74.228.81"
    ["MKT"]="10.74.119.81"
    ["5th"]="10.74.124.81"
    ["NSC"]="10.74.115.81"
    ["NZH"]="10.74.233.81"
    ["RAM"]="10.74.145.81"
    ["Shoubra"]="10.74.220.81"
    ["5th-03"]="10.66.99.241"
    ["NSC-03"]="10.66.99.245"
    ["NZH-03"]="10.66.99.242"
    ["RM-02"]="10.66.99.247"
    ["Shoubra2-2"]="10.66.99.243"
    ["TM-04"]="10.66.99.244"
    ["TM-05"]="10.66.99.68"
    ["RM-03"]="10.66.99.67"
    ["ABR-02"]="10.66.99.69"
    ["5thG-Ring"]="10.74.124.82"
    ["2161"]="10.74.124.84"
    ["680"]="10.74.124.83"
    ["1689"]="10.74.119.83"
    ["2640"]="10.74.119.84"
    ["MKT-2"]="10.74.119.82"
    ["NC"]="10.74.115.82"
    ["3829"]="10.74.115.83"
    ["NZH-2"]="10.74.233.82"
    ["1439"]="10.74.233.83"
    ["Tel"]="10.74.228.82"
    ["2688"]="10.74.228.86"
    ["2288"]="10.74.228.85"
    ["2134"]="10.74.228.87"
    ["1281"]="10.74.228.83"
    ["2108"]="10.74.228.84"
    ["TM-03"]="10.74.228.88"
    ["2255"]="10.74.228.91"
    ["2256"]="10.74.228.89"
)

# Define interfaces for each device
declare -A device_interfaces=(
    ["ABR"]="1/2/LINE 1/6/LINE"
    ["TEL-01"]="1/2/LINE 1/6/LINE"
    ["MKT"]="1/2/LINE 1/6/LINE"
    ["5th"]="1/6/LINE 1/10/LINE"
    ["NSC"]="1/2/LINE 1/6/LINE"
    ["NZH"]="1/2/LINE 1/6/LINE"
    ["RAM"]="1/2/LINE 1/6/LINE"
    ["Shoubra"]="1/2/LINE 1/6/LINE"
    ["5th-03"]="1/2/LINE 1/6/LINE"
    ["NSC-03"]="1/2/LINE 1/4/LINE"
    ["NZH-03"]="1/3/LINE 1/4/LINE"
    ["RM-02"]="1/2/LINE 1/4/LINE"
    ["Shoubra2-2"]="1/2/LINE 1/6/LINE"
    ["TM-04"]="1/2/LINE 1/6/LINE"
    ["TM-05"]="1/2/LINE 1/4/LINE"
    ["RM-03"]="1/2/LINE 1/4/LINE"
    ["ABR-02"]="1/2/LINE 1/4/LINE"
    ["5thG-Ring"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["2161"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["680"]="1/2/LINE 1/3/LINE"
    ["1689"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["2640"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["MKT-2"]="1/2/LINE 1/5/LINE"
    ["NC"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["3829"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["NZH-2"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["1439"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["Tel"]="1/2/LINE 1/3/LINE"
    ["2688"]="1/2/LINE 1/3/LINE"
    ["2288"]="1/2/LINE 1/3/LINE"
    ["2134"]="1/2/LINE 1/3/LINE"
    ["1281"]="1/2/LINE 1/3/LINE 1/5/LINEIN"
    ["2108"]="1/2/LINE 1/5/LINE 1/4/LINEIN"
    ["TM-03"]="1/2/LINE 1/5/LINE"
    ["2255"]="1/2/LINE 1/4/LINE"
    ["2256"]="1/2/LINE 1/5/LINE"
)

# Create an ordered list of devices
ordered_devices=(
    "ABR" "TEL-01" "MKT" "5th" "NSC" "NZH" "RAM" "Shoubra" "5th-03" "NSC-03" "NZH-03" "RM-02" "Shoubra2-2" 
    "TM-04" "TM-05" "RM-03" "ABR-02" "5thG-Ring" "2161" "680" "1689" "2640" "MKT-2" "NC" "3829" "NZH-2" "1439" 
    "Tel" "2688" "2288" "2134" "1281" "2108" "TM-03" "2255" "2256"
)

# Function to capture power readings for a specific interface on a device using Expect
capture_power_readings() {
    local device_name="$1"
    local device_ip="$2"
    local interface="$3"

    # Use Expect to handle telnet and command execution
    output=$(expect -c "
        set timeout 10
        spawn telnet $device_ip
        expect \"login:\"
        send \"root\r\"
        expect \"Password:\"
        send \"ALu12#\r\"
        expect \"#\"
        send \"su - cli\r\"
        expect \"Username:\"
        send \"admin\r\"
        expect \"Password:\"
        send \"admin\r\"
        expect \"Do you acknowledge? (Y/N)\"
        send \"y\r\"
        expect \"#\"
        send \"show interface $interface detail\r\"
        expect \"#\"
        send \"exit\r\"
        send \"logout\r\"
    ")

    # Extract TX and RX power readings from the output
    if [[ "$interface" == *"LINEIN"* ]]; then
        tx_power=$(echo "$output" | grep -oP "Operating Gain\s+:\s+\K[0-9.-]+" | tail -1)
        rx_power=$(echo "$output" | grep -oP "Total Power In\s+:\s+\K[0-9.-]+" | tail -1)
    else
        tx_power=$(echo "$output" | grep -oP "Total Power Out\s+:\s+\K[0-9.-]+" | tail -1)
        rx_power=$(echo "$output" | grep -oP "Total Power In\s+:\s+\K[0-9.-]+" | tail -1)
    fi

    # Assign default values if still missing
    tx_power="${tx_power:-N/A}"
    rx_power="${rx_power:-N/A}"

    # Write to CSV
    echo "$device_name,$interface,$tx_power,$rx_power" >> "$csv_file"
    echo "Captured for $device_name on $interface: TX=$tx_power, RX=$rx_power"
}

# Loop through each device in the ordered list
for device_name in "${ordered_devices[@]}"; do
    device_ip="${devices[$device_name]}"
    echo "Connecting to $device_name ($device_ip)..."

    # Loop through interfaces
    IFS=' ' read -r -a interfaces <<< "${device_interfaces[$device_name]}"
    for interface in "${interfaces[@]}"; do
        echo "Capturing power readings for $device_name on interface $interface..."
        capture_power_readings "$device_name" "$device_ip" "$interface"
    done
done

echo -e "\nData collection complete. Results saved in $csv_file."
echo -e "Logs are available in $log_file."
