setup();
global initialXThreat initialZThreat initialVXThreat initialVZThreat;
global sigmaX sigmaZ;
global timeThreshhold;

%If looping, number of times there was a success
count = 0;

%Options
plots = true;
loop = false;
activateSolenoid = true;

for a = 1:1000
    
    %Change in time between pictures (represents ideal frames/second and update rate)
    dt = 1/25;
    %Total time
    t = 0:dt:5;
    
    
    %TODO: Make folders
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
    x_truth = path.threat(:,3);
    z_truth = path.threat(:,4);
    
    for i = 1:length(t)
        tic;
        realX = threat(i,3);
        realZ = threat(i,4);
        x = realX + randn(1) * sigmaX;
        z = realZ + randn(1) * sigmaZ;
        
        estimate = kfilter(false,x,z,dt);
        time = estimate.time;
        theta = estimate.theta;
        
        x_filtered(i) = theta(1);
        z_filtered(i) = theta(4);
        x_measured(i) = x;
        z_measured(i) = z;
        
        %Its velocity thats the problem
        if time < timeThreshhold
            
            projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),plots)
            %actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), false);
            
            
            
            if(activateSolenoid)
                projectedTime = projectedTime - toc;
                triggerSolenoid(projectedTime);
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
                minDistance;
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
        %x_truth = x_truth(1:i);
        %z_truth = z_truth(1:i);
        x_filtered = x_filtered(1:i);
        z_filtered = z_filtered(1:i);
        
        
        
        plot(x_measured,z_measured,'bo')
        hold on
        plot(x_truth,z_truth,'-g','linewidth',1)
        plot(x_filtered,z_filtered,'-*r','linewidth',2)
        legend('Interceptor','Projected Threat')
        xlim([-40,40]);
        ylim([0.1, 20]);
    end
    
    if(~loop)
        break;
    end
end
