setup();
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
global sigmaX sigmaZ;
global timeThreshhold;

%If looping, number of times there was a success
count = 0;

%Options
loop = false;
activateSolenoid = false;


plots = ~loop;
distances = zeros(1,100);

for a = 1:100
    
    %Change in time between pictures (represents ideal frames/second and update rate)
    dt = 1/2500;
    %Total time
    t = 0:dt:5;
    
    
    %TODO: ESTIMATE DRAG COEEFICIANTS
    
    
    %find the ideal paths of the target and interceptor (only target is used)
    path = getPaths(t, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
    threat = path.threat;
    threat(1,:) = [];
    t(:,1) = [];
    
    kfilter(true, initialXThreat,initialZThreat,0);
    
    x_filtered = zeros(size(t));
    z_filtered = zeros(size(t));
    x_measured = zeros(size(t));
    z_measured = zeros(size(t));
    x_truth = threat(:,1);
    z_truth = threat(:,2);
    
    for i = 1:length(t)
        realX = threat(i,3);
        realZ = threat(i,4);
        x = realX + randn(1) * sigmaX;
        z = realZ + randn(1) * sigmaZ;
        
        estimate = kfilter(false,x,z,dt);
        time = estimate.time;
        theta = estimate.theta;
        
        x_filtered(i) = theta(2);
        z_filtered(i) = theta(5);
        x_measured(i) = x;
        z_measured(i) = z;


        if time < timeThreshhold
            
            %Time to launch
            projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),false);
            actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), false);
            %projectedTime = actualTime;
            if(activateSolenoid)
                projectedTime = projectedTime - toc;
                currentTime = clock;
                triggerSolenoid(projectedTime + currentTime(6));
                break;
            end
            
            if projectedTime ~= Inf && projectedTime > 0
                % projectedTime = actualTime;
                
                %Find the paramaters of the threat when the interceptor is
                %projected to launch
                lastKnownI = fix(projectedTime / dt) + i;
                lastKnownTime = fix(projectedTime / dt) * dt;
                tInterval = 0:0.001:projectedTime-lastKnownTime;
                if length(tInterval) > 1
                    paths = getPaths(tInterval, threat(lastKnownI,3), threat(lastKnownI,4), threat(lastKnownI,1), threat(lastKnownI,2));
                    launchDetails = paths.threat(end, :);
                else
                    launchDetails = threat(lastKnownI,:);
                end
                
                %Check if they would actually intersect
                tInterval = 0:0.001:10;
                paths = getPaths(tInterval, launchDetails(3), launchDetails(4), launchDetails(1), launchDetails(2));
                minDistance = Inf;
                for j = 1:length(tInterval)
                    distance = sqrt((paths.threat(j,3)-paths.interceptor(j,3))^2 + ...
                        (paths.threat(j,4)-paths.interceptor(j,4))^2);
                    if(distance < minDistance)
                        minDistance = distance;
                    end
                end
                
                
                if(loop && minDistance < .13)
                    count = count + 1;
                end
                distances(1, a) = minDistance;
                minDistance
            end
            
            if(loop)
                count / a
            end
            
            break
            
        end
        
    end
    
    if(plots)
        x_measured = x_measured(1:i);
        z_measured = z_measured(1:i);
        x_truth = x_truth(1:i);
        z_truth = z_truth(1:i);
        x_filtered = x_filtered(1:i);
        z_filtered = z_filtered(1:i);
        
        t = t(1:i);
        
        %plot(x_measured,z_measured,'bo')
        hold on
        plot(t,z_filtered - z_truth','-r','linewidth',1)
        
        
        %plot(t, z_filtered,'-r','linewidth',1)
        legend('Difference in Vs')

    end
    
    if(~loop)
        break;
    end
end
if(loop)
    histogram(distances, 10);
end