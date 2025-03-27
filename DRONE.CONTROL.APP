OPEN-WRT--- ID ROOT PASS ROOT

RASPBERYY PI -- ID MEDICAL-DRONE PASS 2081 -- IP 192.168.1.161

sudo apt install python3-venv
python3 -m venv myenv
source myenv/bin/activate -- to exit from myenv just type deactivate then enter in terminal
pip install MAVProxy

-- connect the usb from pixhawk to rpi 
ls /dev/tty*
and note the port usually ttyACM0

--to edit something on nano 
ctrl+shift+6 , then scroll to down to select everything
ctrl k to cut all content if there is something previously
then copy the code and paste . by right clik
ctrl + X , y , enter to exit

***************
to run mavproxy 
-first make sure the port doesn't change every reboot i.e from acm0 to acm1 and so on 

Here's a clear summary of what you've done and the steps to take so you can easily define the udev rule for your Pixhawk (or similar devices) in the future:

Steps to Create a Persistent Udev Rule for Pixhawk:
Identify Your Device:

First, ensure that the device is recognized when connected to the Raspberry Pi.

You can check it using:

bash
Copy
dmesg | grep ttyACM
This shows if your Pixhawk or similar device is detected as /dev/ttyACM0.

Create a Custom Udev Rule:

Udev rules allow the system to assign consistent names or symbolic links to devices based on their properties (like serial number or device name).

Create a new udev rules file:

sudo nano /etc/udev/rules.d/99-pixhawk.rules
In the file, add a rule to create a symbolic link for your device. Example:


KERNEL=="ttyACM*", ACTION=="add", SUBSYSTEM=="tty", SYMLINK+="pixhawk_cube_black"

Explanation:

KERNEL=="ttyACM*": Matches devices with names starting with ttyACM, which is how your Pixhawk is typically named.

ACTION=="add": Triggers the rule when the device is added (plugged in).

SUBSYSTEM=="tty": Ensures the rule applies to devices under the tty subsystem (which includes serial devices).

SYMLINK+="pixhawk_cube_black": Creates the symbolic link /dev/pixhawk_cube_black.

Reload and Apply Udev Rules: After saving the file, reload the udev rules:

bash
Copy
sudo udevadm control --reload-rules
sudo udevadm trigger
Verify the Symbolic Link: Check that the symbolic link /dev/pixhawk_cube_black is created and points to /dev/ttyACM0:

bash
Copy
ls -l /dev/pixhawk_cube_black
The output should show something like:

bash
Copy
lrwxrwxrwx 1 root root 7 Mar 27 16:37 /dev/pixhawk_cube_black -> ttyACM0
Test the Link: You can now refer to your Pixhawk as /dev/pixhawk_cube_black instead of /dev/ttyACM0 in your scripts or applications. Test if it's working correctly:

bash
Copy
ls -l /dev/pixhawk_cube_black
Ensure Permissions:

If your user doesn't have access to the device, make sure they're part of the dialout group (which typically has access to serial devices):

bash
Copy
sudo usermod -aG dialout $USER
After adding the user to the group, log out and log back in to apply the change.

Reboot the System:

After rebooting, check if the symbolic link is still created automatically. This ensures the rule persists across reboots:

bash
Copy
ls -l /dev/pixhawk_cube_black
Troubleshooting Tips:
If the symbolic link doesn’t work as expected, run:

bash
Copy
sudo udevadm monitor --udev
This command helps you see the udev events in real time, so you can check if there are any errors or if the rule is not being applied correctly.

If there’s a conflict, check other existing udev rules in /etc/udev/rules.d/ that might be affecting the device.








