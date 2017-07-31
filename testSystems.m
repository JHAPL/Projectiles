clear
clc
%%
camera = webcam(1);
camera.Resolution = '352x288';

while(1 == 1)
    pic = snapshot(camera);
    h = calc(pic);
    if h(1) == 1 
       g = 5;
       triggerSolenoid(g)
    end
end