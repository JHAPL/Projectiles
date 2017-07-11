%Change in time (represents ideal frames/second and update rate)
dt = 1/30;
%Total time
t = 0:dt:3;
sigmaX = 0.5;
sigmaZ = 0.5;


%find the ideal paths of the target and interceptor (only target is used)
path = getPaths(t, -20, 0, 20 * cos(pi / 4), 20 * sin(pi / 4));
threat = path.threat;
threat(1,:) = [];
t(:,1) = [];

kfilter(true, false, -20,0,0);
time = 0;
for i = 1:length(t)
    x = threat(i,3)' + randn(1) * sigmaX;
    z = threat(i,4)' + randn(1) * sigmaZ;
    tic
    time = kfilter(false, mod(i, 5) == 0,x,z,dt)
    toc
    if(time < .4)
        break
    end
end
elapsed = toc;
time - elapsed