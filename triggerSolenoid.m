function z = triggerSolenoid(projectedTime)
tic;
pin = 7;
rpi = raspi
configureDigitalPin(rpi,pin,'output');
% writeDigitalPin(rpi,pin,0);

while true
    
    projectedTime - toc

    if projectedTime - toc < 0
    
        disp('pew')
        writeDigitalPin(rpi,pin,1);
        
        break;

    end
    
end

end