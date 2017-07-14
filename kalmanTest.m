%Change in time (represents ideal frames/second and update rate)
dt = 1/25;
%Total time
t = 0:dt:5;
sigmaX = 0.1;
sigmaZ = 0.1;


%TODO Make folders
setGlobal();
global initialXThreat initialZThreat initialVXThreat initialVZThreat;



%find the ideal paths of the target and interceptor (only target is used)
path = getPaths(t, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
threat = path.threat;
threat(1,:) = [];
t(:,1) = [];

kfilter(true, false, initialXThreat,initialZThreat,0);
time = 0;
tic
for i = 1:length(t)
    x = threat(i,3)' + randn(1) * sigmaX;
    z = threat(i,4)' + randn(1) * sigmaZ;
    tic
    time = kfilter(false, mod(i, 5) == 1,x,z,dt);
    toc
    if(time < .4)
        actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), true)
        break
    end
end
toc
