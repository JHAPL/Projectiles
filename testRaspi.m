system(rpi, 'sudo su');
%system(rpi, 'echo 2 > /sys/class/gpio/unexport');
system(rpi, 'echo 2 > /sys/class/gpio/export');
system(rpi, 'echo out > /sys/class/gpio/gpio2/direction');

while true 
    system(rpi, 'echo 1 > /sys/class/gpio/gpio2/value');
    pause(2);
    system(rpi, 'echo 0 > /sys/class/gpio/gpio2/value');
    pause(2);
end


if(activateSolenoid)
            projectedTime = projectedTime - toc;
            currentTime = clock;
            triggerSolenoid(projectedTime + currentTime(6));
            break;
        end