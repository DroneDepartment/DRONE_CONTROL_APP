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

udevadm info -q all -n /dev/ttyACM0 | grep "ID_SERIAL"

copy the serial num -- Hex_ProfiCNC_CubeBlack_1C003E000751363033383531

sudo nano /etc/udev/rules.d/99-pixhawk.rules

add the line with updated serial and name 
SUBSYSTEM=="tty", ATTRS{serial}=="Hex_ProfiCNC_CubeBlack_1C003E000751363033383531", SYMLINK+="pixhawk_cube_black"

sudo udevadm control --reload-rules

ls -l /dev/pixhawk_cube_black




