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








