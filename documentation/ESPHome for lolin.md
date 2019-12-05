
https://domoticaencasa.es/esphome-tutorial-instalacion-esp32-esp8266/

as docker:
https://esphome.io/guides/getting_started_command_line.html

voluptuos problem in ubuntu:
https://github.com/esphome/issues/issues/591

problem with compiling/upload:
I was able to get past this by deleting one of the instances of the ESPAsyncTCP library:
sudo rm -rf "ESPHome/my_esp_project/.piolibdeps/ESPAsyncTCP_ID305"