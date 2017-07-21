function z = triggerSolenoid(launchTime)

pin = 3;

configureDigitalPin(rpi,pin,'output');
writeDigitalPin(rpi,pin,0);
writeDigitalPin(rpi,pin,1);