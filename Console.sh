################################################################################################
#FIREALARM SYSTEM PROTOTYPE####
#Created by Morgan Hester, Rachel Martin, and Nathan Workman
#Version Number: .01
#This is the Main Console, it handles all the software, the subconsole is at pi@152.41.14.214
#Please ensure all equipment is wired correctly!
#The Log File is Stored at /home/pi/FireSys/Log/FireHis.log
#Date Last Updated: 4/24/19
################################################################################################

FIRE_LOG="/home/pi/FireSys/Log/FireHis.log"
pi2=$(ssh 152.41.14.214 /home/pi/FireSys/Main ./Console.sh)
BUTTON2=$(gpio -g read 12)
BUTTON=$(gpio -g read 16)


while [ 1 ]; do
	BUTTON2=$(gpio -g read 12)
	TEMP=$(./Temp.py 11 22)
	if [ ${TEMP} -gt 130 ]; then
		pitemp=$(ssh 152.41.14.214 cat pitemp.sh)
		echo ${pitemp}
		if [ ${pitemp} -ge 100 ]; then
			echo $(date "+%Y-%m-%d %H:%M:%S") >>${FIRE_LOG}
			echo 'FIRE at HOK109! Temp: ' ${TEMP} >>${FIRE_LOG}
			BUTTON=$(gpio -g read 16)
			while [ ${BUTTON} -eq 0 ]; do
				gpio -g write 21 1 #sprink ON
				ssh 152.41.14.214 gpio -g write 20 0 #ALARM Pi 2 ON
				ssh 152.41.14.214 gpio -g write 21 1 #sprink Pi 2 ON
				gpio -g write 20 0 #alarm on
				BUTTON=$(gpio -g read 16)
			done
			gpio -g write 21 0 #sprinkler OFF
			gpio -g write 20 1 #ALARM OFF
			ssh 152.41.14.214 gpio -g write 21 0 #sprink Pi 2 OFF
			ssh 152.41.14.214 gpio -g write 20 1 #ALARM Pi 2 OFF
		elif [ ${pitemp} -lt 100 ]; then
			echo "Check your system for faulty hardware. Contact support at ###-###-####" 
		else #error in pi 2
			echo $(date "+%Y-%m-%d %H:%M:%S") >>${FIRE_LOG}
			echo 'FIRE at HOK109! Temp: ' ${TEMP} >>${FIRE_LOG}
			BUTTON=$(gpio -g read 16)
			while [ ${BUTTON} -eq 0 ]; do
				gpio -g write 20 0 #alarm on
				gpio -g write 21 1 #sprinkler on
				ssh 152.41.14.214 gpio -g write 20 0 #ALARM Pi 2 ON
				ssh 152.41.14.214 gpio -g write 21 1 #sprink Pi 2 ON
				BUTTON=$(gpio -g read 16)
			done
			gpio -g write 21 0 #sprinkler OFF
			gpio -g write 20 1 #ALARM OFF
			ssh 152.41.14.214 gpio -g write 21 0 #sprink Pi 2 OFF
			ssh 152.41.14.214 gpio -g write 20 1 #ALARM Pi 2 OFF
		fi
	elif [ ${BUTTON2} -eq 1 ]; then
		echo $(date "+%Y-%m-%d %H:%M:%S") >>${FIRE_LOG}
		echo 'System Test. Temp: ' ${TEMP} >>${FIRE_LOG}
		BUTTON=$(gpio -g read 16)
		echo ALARM TEST
		while [ ${BUTTON} -eq 0 ]; do
			gpio -g write 20 0 #alarm on
			gpio -g write 21 1 #sprinkler on
			ssh 152.41.14.214 gpio -g write 20 0 #ALARM Pi 2 ON
			ssh 152.41.14.214 gpio -g write 21 1 #sprink Pi 2 ON
			BUTTON=$(gpio -g read 16)
		done
		gpio -g write 21 0 #sprinkler OFF
		gpio -g write 20 1 #ALARM OFF
		ssh 152.41.14.214 gpio -g write 21 0 #sprink Pi 2 OFF
		ssh 152.41.14.214 gpio -g write 20 1 #ALARM Pi 2 OFF
	fi
done
