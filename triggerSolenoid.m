function z = triggerSolenoid(projectedTime)

pin = 7;
tic;

while true
    projectedTime - toc
    if projectedTime - toc < 0
        disp('pew')
        
        %configureDigitalPin(rpi,pin,'output');
        %writeDigitalPin(rpi,pin,0);
        %writeDigitalPin(rpi,pin,1);
        
        break;
    end
    
end

end