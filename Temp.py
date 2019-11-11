#!/usr/bin/python
import sys
import os
import Adafruit_DHT



sensor_args = { '11': Adafruit_DHT.DHT11,
                '22': Adafruit_DHT.DHT22,
                '2302': Adafruit_DHT.AM2302 }
if len(sys.argv) == 3 and sys.argv[1] in sensor_args:
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
else:
    print('Usage: sudo ./Adafruit_DHT.py [11|22|2302] <GPIO pin number>')
    print('Example: sudo ./Adafruit_DHT.py 2302 4 - Read from an AM2302 connected to GPIO pin #4')
    sys.exit(1)

# Try to grab a sensor reading.  Use the read_retry method which will retry up
# to 15 times to get a sensor reading (waiting 2 seconds between each retry)
humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

temperature = temperature * 9/5.0 + 32
temperature = int(temperature)


if humidity is not None and temperature is not None:
    print('{0:0}'.format(temperature))
else:
    print('Failed to get reading. Try again!')
    sys.exit(1)
#################################################
