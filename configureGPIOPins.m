clear;
rpi = raspi;
pins = rpi.AvailableDigitalPins;

for i = 1:length(pins)
    
    configureDigitalPin(rpi, pins(i), 'output');
    writeDigitalPin(rpi, pins(i), 0);
    
end