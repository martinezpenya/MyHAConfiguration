# Arduino for Lolin

Arduino installation for Ubuntu.

1. Download arduino.tar.xz from arduino website (version 1.8.5).
    tar -xf arduino-1.8.5-linux64.tar.xz
2. Uncompress downloaded file, move to user folder (~), and execute ./install.sh
3. Run arduino IDE

Arduino preparation for Lolin (libraries):

1. Navigate installation folder and create new folder named "portable"
2. Open Arduino IDE and in *File/Preferences* in *Additional Boards Manager URL's* paste this URL: http://arduino.esp8266.com/versions/2.5.0-beta2/package_esp8266com_index.json
                                                                     this, if previous won't work: http://arduino.esp8266.com/stable/package_esp8266com_index.json
3. Now go to *Tools/Board/Board Manager* and search for *esp8266* and download version 2.3.0 install it and close this window
4. Now go to *Skech/LIbrary/Manage* Libraries and search for *pubsub* and install PubSubClient by Nick O'Leary (version 2.6.0)
5. Install "DHT sensor library 1.3.0"
6. Install "Adafruit Unified Sensor 1.0.2"
7. In the same windows search for *json* and install ArduinoJson by Benoit Blanchon (version 5.8.3) and close this window
8. Go back to arduino "portable" folder we've created previously and navigate to portable/sketchbook/libraries/pubsubclient/src and edit pubsubclient.h open with your favorite text editor and change value on line `#define MQTT_MAX_PACKET_SIZE 128` to `#define MQTT_MAX_PACKET_SIZE 512`
9. Save and close editor
10. In Arduino IDE copy source for sensor from: https://github.com/martinezpenya/ESP-MQTT-JSON-Multisensor.git it's a fork from https://github.com/bruhautomation/ESP-MQTT-JSON-Multisensor/tree/master/bruh_mqtt_multisensor_github

