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








