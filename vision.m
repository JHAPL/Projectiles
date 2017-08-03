%% test
clear
clc
%%
% assigining the camera a value
camR = webcam(1);
camL = webcam(2);
% lowering camera resolution
camR.Resolution = '352x288';
camL.Resolution = '352x288';

q = 0;
while true
    picR = snapshot(camR);
    picL = snapshot(camL);
    r = calc(picR);
    l = calc(picL);
    q = q + 1;
    if r(1) == 1 && l(1) == 1
       coordinateConverter(r(2), r(3), l(2), l(3))
    end
end
