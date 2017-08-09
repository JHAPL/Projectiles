setup();

global initialXThreat initialZThreat initialVXThreat initialVZThreat;
global timeThreshhold sigmaX sigmaZ;

%Loop variables
range = 0.01:0.01:3;
numTimes = 200;

%Options
loop = false;
activateSolenoid = false;
debugging = false;
makeMovie = false;

plots = ~loop && ~makeMovie;
ratios = zeros(1, length(range));


%Change in time between pictures (represents ideal frames/second and update rate)
dt = 1/25;
maxTime = 2.56;


global a_sigma Sw;

for c = range
    if(loop)
        c / range(1)
        a_sigma = c;
        Sw = a_sigma ^ 2 / 25;
        count = 0;
    end
    for a = 1:numTimes
        
        %Total time
        t = 0:dt:maxTime;
        
        
        %find the ideal paths of the target and interceptor (only target is used)
        path = getPaths(t, initialXThreat, initialZThreat, initialVXThreat, initialVZThreat);
        threat = path.threat;
        threat(1,:) = [];
        t(:,1) = [];
        
        kfilter(true, initialXThreat,initialZThreat,dt);
        
        x_filtered = zeros(size(t));
        z_filtered = zeros(size(t));
        x_measured = zeros(size(t));
        z_measured = zeros(size(t));
        x_truth = threat(:,3);
        z_truth = threat(:,4);
        
        vx_filtered = zeros(size(t));
        vz_filtered = zeros(size(t));
        vx_truth = threat(:,1);
        vz_truth = threat(:,2);
        
        frames(1) = getframe;
        
        
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
            
            vx_filtered(i) = theta(2);
            vz_filtered(i) = theta(5);
            
            
            if(makeMovie)
                plot(x_measured(1:i),z_measured(1:i),'bo')
                hold on
                plot(x_truth(1:i),z_truth(1:i),'-g','linewidth',3)
                plot(x_filtered(1:i),z_filtered(1:i),'-*r','linewidth',1)
                %projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),true);
                %actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), true);

                xlim([-20,0])
                ylim([0,10])
                
                frames(i) = getframe;
                hold off
            end
            
            if time < timeThreshhold && z_filtered(i) > 5
                %Time to launch
                tic
                projectedTime = trajectorymodel(theta(1), theta(4), theta(2), theta(5),plots && ~debugging);
                toc
                %actualTime = trajectorymodel(threat(i,3), threat(i,4), threat(i,1), threat(i,2), plots && ~debugging);
                %projectedTime = actualTime;
                
                if(projectedTime < 0 || projectedTime == Inf)
                    %disp("Invalid Time Estimate");
                    break;
                end
                
                if(activateSolenoid)
                    projectedTime = projectedTime - toc;
                    triggerSolenoid(projectedTime);
                    break;
                end
                
                
                %Find the paramaters of the threat when the interceptor is
                %projected to launch
                lastKnownI = fix(projectedTime / dt) + i;
                lastKnownTime = fix(projectedTime / dt) * dt;
                tInterval = 0:0.001:projectedTime - lastKnownTime;
                if length(tInterval) > 1
                    paths = getPaths(tInterval, threat(lastKnownI,3), threat(lastKnownI,4), threat(lastKnownI,1), threat(lastKnownI,2));
                    launchDetails = paths.threat(end, :);
                else
                    launchDetails = threat(lastKnownI,:);
                end
                
                %Check if they would actually intersect
                global interceptorTime;
                paths = getPaths(interceptorTime, launchDetails(3), launchDetails(4), launchDetails(1), launchDetails(2));
                minDistance = Inf;
                for j = 1:length(interceptorTime)
                    distance = sqrt((paths.threat(j,3)-paths.interceptor(j,3))^2 + ...
                        (paths.threat(j,4)-paths.interceptor(j,4))^2);
                    if(distance < minDistance)
                        minDistance = distance;
                    end
                end
                
                if(loop && minDistance < .13)
                    count = count + 1;
                end
                if(~loop)
                    disp(minDistance)
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
            
            vx_truth = vx_truth(1:i);
            vz_truth = vz_truth(1:i);
            vx_filtered = vx_filtered(1:i);
            vz_filtered = vz_filtered(1:i);
            
            
            if(~debugging)
                plot(x_measured,z_measured,'bo')
                hold on
                plot(x_truth,z_truth,'-g','linewidth',1)
                plot(x_filtered,z_filtered,'-*r','linewidth',2)
                legend('Interceptor','Projected Threat')
                xlim([-20,0])
                ylim([0,10])
            else
                t = t(1:i);
                plot(t,vz_filtered - vz_truth','-r','linewidth',1)
                hold on
                %plot(t,vx_filtered - vx_truth','-b','linewidth',1)
                
                hold on
                firstParts = x_filtered(1, 1:length(x_filtered) - 1);
                secondParts = x_filtered(1, 2:length(x_filtered));
                vs = secondParts - firstParts;
                vs = vs./dt;
                vx_truth(1,:) = [];
                t = t(2:i);
                %plot(t, vs' - vx_truth);
                legend('Difference in model vzs','Finite diffs')
                
            end
            
            
        end
        
        if(~loop)
            break;
        end
    end
    
    if(~loop)
        break;
    else
        ratio = count / a;
        ratios(1, round(c / range(1))) = ratio;
    end
end
if(makeMovie)
    frames = frames(1:i);
end
