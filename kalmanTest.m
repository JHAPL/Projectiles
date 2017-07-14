%Change in time (represents ideal frames/second and update rate)
dt = 1/30;
%Total time
t = 0:dt:3;
sigmaX = 0.5;
sigmaZ = 0.5;

%TODO: Something is wrong here

%find the ideal paths of the target and interceptor (only target is used)
path = getPaths(t, -35, 0, 10, 20);
threat = path.threat;
threat(1,:) = [];
t(:,1) = [];

kfilter(true, false, -35,0,0);
time = 0;
tic
for i = 1:length(t)
    x = threat(i,3)' + randn(1) * sigmaX;
    z = threat(i,4)' + randn(1) * sigmaZ;
    time = kfilter(false, mod(i, 5) == 1,x,z,dt)
    if(time < .4)
        actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), true)
        break
    end
end
toc
