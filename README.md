# raspberrypi-camera-tests
Raspberry Pi  - Initial setup and testing
=========================================

Using: Raspberry Pi 3 Model B, MacBook Air (13-inch, Late 2010)

Create NOOBS microSD card
----------------------------

* Get latest NOOBS (NOOBS Lite) from: https://www.raspberrypi.org/downloads/noobs/  
I used NOOBS_lite_v1_9.zip, (old versions archived here: https://downloads.raspberrypi.org/NOOBS/images/)
* Unzip the NOOBS zip file.
* Copy the folder to the microSD card (used an microSD to SD adapter).

First boot
--------------

* Insert the microSD card.
* plug in the Mouse, Keyboard and hdmi.
* Plug in the power with microUSB to start the first boot process.
* A prompt appears to choose wifi network and enter password.
* A window will appear with a list of different operating systems.
* Choose Raspbian and click install, Raspian will install.
* When the installation is complete click "ok".
* Raspian GUI will start.

Installing RPi Camera
---------------------

* Connect camera with flex cable (with RPi off)
* Enable camera:
```
sudo raspi-config
```
* Select enable camera and hit Enter, Finish and it will reboot.
* To turn red camera LED off: add "disable_camera_led=1" in the /boot/config.txt
```
sudo nano /boot/config.txt
```
* Show options
```
raspistill 2>&1 | less
```
* Capture a photo (max size is 2592 x 1944)
```
raspistill -o cam.jpg

DATE=$(date +"%Y-%m-%d_%H%M")
raspistill --nopreview  -h 194 -w 259 -o /home/pi/camera/$DATE.jpg
```
* setup cron job
```
crontab -e
```
* Put this text in the file with nano, the cron job will start
```
* * * * * /home/pi/camera.sh 2>&1
```
* Alternatively these make videos
```
raspivid -o vid.h264 --timeout 5000
raspivid -o vid.mpeg --timeout 5000 --codec MJPEG
```

Install web server
------------------
```
sudo apt-get update 
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y
```

Script to copy to webserver
---------------------------
* Create the camera.sh file (contents below) and the ~/camera directory
```
#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H%M")

# max image size 2592 x 1944

# raspistill --nopreview -w 259 -h 194 -o /home/pi/camera/$DATE.jpg
# raspistill --nopreview -o /home/pi/camera/$DATE.jpg
raspistill --nopreview -w 518 -h 388 -vf -hf -o /home/pi/camera/$DATE.jpg

rm /home/pi/camera/index.html  
printf "<html>\n<head></head>\n<body>\n" >> /home/pi/camera/index.html  
printf "Last 10 Minutes shown - Time now: $DATE<br>\n" >> /home/pi/camera/index.html  

for img in $(ls -t /home/pi/camera/*.jpg | head -n 10); do
  printf "<img src=\"$(basename $img)\" width=\"900\">\n" >> /home/pi/camera/index.html  
done
printf "</body>\n</html>\n" >> /home/pi/camera/index.html  

sudo cp -r /home/pi/camera /var/www/html/
```
* cron job is already working (see above)

Packages to send email (SSMTP)
----------------------
Following http://www.sbprojects.com/projects/raspberrypi/exim4.php
* install these packages
```
sudo apt-get install ssmtp mailutils mpack
```
* Edit /etc/ssmtp/ssmtp.conf
```
sudo nano /etc/ssmtp/ssmtp.conf
```
* Write the following in the file:
```
mailhub=smtp.gmail.com:587
hostname=raspberrypi
AuthUser=YOUR-RPi-ACCOUT@gmail.com
AuthPass=REQUEST-GMAIL-PASSWORD-FOR-THIS-APP
useSTARTTLS=YES
```
* Setup aliases in /etc/aliases
```
# /etc/aliases
mailer-daemon: postmaster
postmaster: root
nobody: root
hostmaster: root
usenet: root
news: root
webmaster: root
www: root
ftp: root
abuse: root
noc: root
security: root
root: pi
pi: YOUR-RPi-ACCOUT@gmail.com
```
* Then run:
```
sudo newaliases
```
* Setup full name for the user pi
```
sudo chfn -f "pi @ domotics" pi
```
* Test email from YOUR-RPi-ACCOUT@gmail.com to ANYRECIPIENT@gmail.com
```
echo "sample text" | mail -s "Important subject" ANYRECIPIENT@gmail.com
mpack -s "Photo" camera/2016-06-24_1257.jpg ANYRECIPIENT@gmail.com
```
