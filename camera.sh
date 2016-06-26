#!/bin/bash

# echo "test" | mail -a camera/2016-06-24_1018.jpg -s TEST haig.djambazian@gmail.com

N=100;
DATE=$(date +"%Y-%m-%d_%H%M")

# max image size 2592 x 1944

# raspistill --nopreview -w 259 -h 194 -o /home/pi/camera/$DATE.jpg
# raspistill --nopreview -o /home/pi/camera/$DATE.jpg

raspistill --nopreview -w 518 -h 388 -vf -hf -o /home/pi/camera/$DATE.jpg

cp loopscript.js /home/pi/camera/

HTML=/home/pi/camera/index.html

rm $HTML

printf "<!doctype html>\n" >> $HTML
printf "<html>\n" >> $HTML
printf "<head>\n" >> $HTML
printf "<title>Webcam</title>\n" >> $HTML
printf "<script src=\"loopscript.js\"></script>\n" >> $HTML
printf "</head>\n" >> $HTML
printf "<body>\n" >> $HTML

printf "Last $N Minutes shown - Time now: $DATE<br>\n" >> $HTML

img=$(ls -rt /home/pi/camera/*.jpg | head -n 1)
printf "<img id=\"mainimg\" width=\"900\" src=\"$(basename $img)\"><br>\n" >> $HTML

printf "<br>\n" >> $HTML
printf "<br>\n" >> $HTML
printf "<br>\n" >> $HTML

printf "<div>\n" >> $HTML
for img in $(ls -rt /home/pi/camera/*.jpg | head -n $N); do
  printf "<img src=\"$(basename $img)\" /><br>\n" >> $HTML
done
printf "</div>\n" >> $HTML

printf "</body>\n" >> $HTML
printf "</html>\n" >> $HTML

sudo rsync -rtv  /home/pi/camera /var/www/html/
