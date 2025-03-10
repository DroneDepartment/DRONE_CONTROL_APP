OPEN-WRT--- ID ROOT PASS ROOT

RASPBERYY PI -- ID MEDICAL-DRONE PASS 2081 -- IP 192.168.1.161

FIRST_TIME_RUN
source mavproxy-env/bin/activate
mavproxy.py --master=tcp:127.0.0.1:5760 --console --map
