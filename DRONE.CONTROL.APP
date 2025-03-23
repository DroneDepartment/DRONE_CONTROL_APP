OPEN-WRT--- ID ROOT PASS ROOT

RASPBERYY PI -- ID MEDICAL-DRONE PASS 2081 -- IP 192.168.1.161

sudo apt install python3-venv
python3 -m venv myenv
source myenv/bin/activate -- to exit from myenv just type deactivate then enter in terminal
pip install MAVProxy

-- connect the usb from pixhawk to rpi 
ls /dev/tty*
and note the port usually ttyACM0

-- now setting up firmware update to pixhawk directly from RPI 

 Create the Python Script
Open a terminal on your Raspberry Pi.

Create a new Python script file, for example, trigger_dfu.py:
nano trigger_dfu.py
Add the following Python code to the file. This script will send a signal over the serial port to enter DFU mode (make sure to adjust the serial port name, e.g., /dev/ttyACM0):


import serial
import time

# Replace this with the correct serial port where your Pixhawk is connected
pixhawk_port = '/dev/ttyACM0'  # This is the most common port
baudrate = 115200  # Baudrate should match the Pixhawk's settings

try:
    # Open the serial port connection
    ser = serial.Serial(pixhawk_port, baudrate)
    time.sleep(1)

    # Send the bootloader trigger sequence to Pixhawk
    ser.write(b'~' * 10)  # You may need to adjust this command as needed
    time.sleep(2)  # Wait to make sure DFU mode is triggered

    # Close the serial connection
    ser.close()

    print("Pixhawk should now be in DFU mode.")
except Exception as e:
    print(f"Error: {e}")

Explanation:

pixhawk_port: The serial port where the Pixhawk is connected (/dev/ttyACM0 is a common name for Pixhawk in Linux, but you can confirm this by running ls /dev/tty*).

ser.write(b'~' * 10): Sends the bootloader trigger sequence (you may need to adjust this sequence depending on your Pixhawk version).

Save and exit by pressing CTRL+X, then Y to confirm saving, and Enter to exit.

0-----0-------0
Now to fetch firmware list and download into the system and upload the selected one 

pip3 install requests
nano firmware_update.py

import requests
import os
import subprocess

# URL of ArduPilot GitHub releases
ARDUPILOT_RELEASES_URL = 'https://api.github.com/repos/ArduPilot/ardupilot/releases'

# Path to download firmware
DOWNLOAD_DIR = '/tmp/ardupilot_firmware'

# Ensure the download directory exists
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

def fetch_firmware_versions():
    """Fetch available firmware versions from ArduPilot's GitHub."""
    print("Fetching available firmware versions...\n")
    response = requests.get(ARDUPILOT_RELEASES_URL)
    if response.status_code != 200:
        print("Failed to fetch data from ArduPilot releases.")
        return []
    releases = response.json()
    firmware_versions = []
    for release in releases:
        for asset in release['assets']:
            # Filtering for .apj firmware files
            if asset['name'].endswith('.apj'):
                firmware_versions.append({
                    'version': release['tag_name'],
                    'firmware_url': asset['browser_download_url'],
                    'firmware_name': asset['name']
                })
    return firmware_versions

def select_firmware(firmware_versions):
    """Allow user to select the firmware version to download."""
    if not firmware_versions:
        print("No firmware files found.")
        return None

    # Display the list of available firmware versions
    print("Available firmware versions:")
    for idx, firmware in enumerate(firmware_versions):
        print(f"{idx + 1}. {firmware['version']} ({firmware['firmware_name']})")

    # User selects firmware
    while True:
        try:
            choice = int(input("\nEnter the number of the firmware you want to download: ")) - 1
            if 0 <= choice < len(firmware_versions):
                return firmware_versions[choice]
            else:
                print("Invalid choice. Try again.")
        except ValueError:
            print("Invalid input. Please enter a number.")

def download_firmware(firmware):
    """Download the selected firmware to the specified directory."""
    print(f"Downloading firmware: {firmware['firmware_name']}...\n")
    response = requests.get(firmware['firmware_url'], stream=True)
    if response.status_code == 200:
        firmware_path = os.path.join(DOWNLOAD_DIR, firmware['firmware_name'])
        with open(firmware_path, 'wb') as fw_file:
            for chunk in response.iter_content(chunk_size=128):
                fw_file.write(chunk)
        print(f"Firmware downloaded to {firmware_path}")
        return firmware_path
    else:
        print("Failed to download firmware.")
        return None

def upload_firmware(firmware_path):
    """Upload the firmware to the Pixhawk using dfu-util."""
    print(f"Flashing firmware: {firmware_path} to Pixhawk...")
    result = subprocess.run(
        ['sudo', 'dfu-util', '-D', firmware_path],
        capture_output=True, text=True
    )
    if result.returncode == 0:
        print("Firmware successfully flashed to Pixhawk!")
    else:
        print(f"Error flashing firmware: {result.stderr}")

def main():
    # Fetch firmware versions from ArduPilot
    firmware_versions = fetch_firmware_versions()

    # Let the user select a firmware version
    firmware = select_firmware(firmware_versions)
    if not firmware:
        return

    # Download the selected firmware
    firmware_path = download_firmware(firmware)
    if not firmware_path:
        return

    # Upload the firmware to Pixhawk
    upload_firmware(firmware_path)

if __name__ == '__main__':
    main()
ctrl k to cut all content if there is something previously
then copy the code and paste . by right clik
ctrl + X , y , enter to exit










