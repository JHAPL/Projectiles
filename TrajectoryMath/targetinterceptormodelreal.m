clear;
clc;
tic;
%Finding the intersection of an Intercontinental Ballistic Kickball and raquetball intercepting missile
%Future things to do:
%1)Learn the ode45 thing
%2)Important: Make sure this model is actually accurate
%Test Aram

%Constants
%Note, a '2' represents the target
time = 0:.01:9.99; %seconds
mass = .0427; %kilograms
mass2 = 1.134; %''  
crossSectionalArea = (2.25 / 12 * .3048 / 2)^2 * pi; %meters
crossSectionalArea2 = (10 / 12 * .3048 / 2)^2 * pi; %''
coefficentOfDrag = .47; %will later be determined by testing
coefficentOfDrag2 = .47; %''
density = 1.225; %of the air in kg/m^3
velocity = 180; %meters/second
velocity2 = 15; %''
theta = 5 / 180 * pi; %degrees
theta2 = 45 / 180 * pi; %''
n = 1;
 
%initial velocities
vx0 = -cos(theta) * velocity;
vy0 = sin(theta) * velocity;
vx02 = cos(theta2) * velocity2;
vy02 = sin(theta2) * velocity2;
 
%Empty Matrices (for now)
vx = zeros(1000, 1);
vy = zeros(1000, 1);
vx2 = zeros(1000, 1);
vy2 = zeros(1000, 1);
airResx = zeros(1000, 1);
airResy = zeros(1000, 1);
airResx2 = zeros(1000, 1);
airResy2 = zeros(1000, 1);
dx = zeros(1000, 1);
dy = zeros(1000, 1);
dx2 = zeros(1000, 1);
dy2 = zeros(1000, 1);
accelx = zeros(1000, 1);
accely = zeros(1000, 1);
accelx2 = zeros(1000, 1);
accely2 = zeros(1000, 1);
possiblepointx = zeros(1000, 1000);
possiblepointy = zeros(1000, 1000);
 
%Some initial values for matrices
vx(1) = vx0;
vy(1) = vy0;
vx2(1) = vx02;
vy2(1) = vx02;
 
%Let loop start
dy(1) = .00001;
 
%This loop essentially determines the change in position and velocity of 
%the target and interceptor and adds to the previous position and velocity
%to determine current values at time = n
 
while n < length(time)
    
    %Stop calculating once interceptor hits the ground
    if n > 1 && dy(n-1) < 0    
        break
    end
    
    %Interceptor air resistance
    airResFX = crossSectionalArea * coefficentOfDrag * density / 2 * vx(n) * vx(n);
    airResFY = crossSectionalArea * coefficentOfDrag * density / 2 * vy(n) * vy(n);
    airResx(n) = airResFX / mass;
    airResy(n) = airResFY / mass;
    accelx(n) = airResx(n);
    accely(n) = -airResy(n) - 9.81;
    
    %Target air resistance
    airResFX2 = crossSectionalArea2 * coefficentOfDrag2 * density / 2 * vx2(n) * vx2(n);
    airResFY2 = crossSectionalArea2 * coefficentOfDrag2 * density / 2 * vy2(n) * vy2(n);
    airResx2(n) = airResFX2 / mass2;
    airResy2(n) = airResFY2 / mass2;
    accelx2(n) = -airResx2(n);
    accely2(n) = -airResy2(n) - 9.81;
    
    %Find new velocities by adding change in velocity to old velocity
    if n > 1
     
        vx(n+1) = vx(n) + accelx(n) * .01;
        vy(n+1) = vy(n) + accely(n) * .01;
        vx2(n+1) = vx2(n) + accelx2(n) * .01;
        vy2(n+1) = vy2(n) + accely2(n) * .01;
    
    %If it's inital, add to initial velocity bruh
    else
        
        vx(n+1) = vx0 + accelx(n) * .01;
        vy(n+1) = vy0 + accely(n) * .01;
        vx2(n+1) = vx02 + accelx2(n) * .01;
        vy2(n+1) = vy02 + accely2(n) * .01;
    
    end
    
    %Find new positions by adding change in position to previous position
    if n > 1
        
        dx(n+1) =  vx(n+1) * .01 + dx(n);
        dy(n+1) =  vy(n+1) * .01 + dy(n);
        dx2(n+1) =  vx2(n+1) * .01 + dx2(n);
        dy2(n+1) =  vy2(n+1) * .01 + dy2(n);
        
    else
        
        dx(n+1) = 50 + vx0 * .01;
        dy(n+1) = vy0 * .01;
        dx2(n+1) = vx02 * .01;
        dy2(n+1) = vy02 * .01;
    
    end
    
    %Add .01 of a second
    n = n + 1;
    
end
 
%new counters
 
%possiblepoint's row counter
j = 1;
%another counter for possiblepoint's rows
mass = 1;
%counter for possiblepoint's columns, REPRESENTS TIME
o = 1;
%counter for the number of almost-intersection points
k = 0;
 
%represents the sum of the almost-intersection points, will be divided by k
%to find the mean intersection point. Includes time to find average time it
%takes for target to reach the intersection point.
totalx = 0;
totaly = 0;
totalt = 0;
 
%find every single possible difference of dx and dx2 as well as dy and dy2
while j < length(time)
       
       possiblepointx(j, :) = dx(j) - dx2;
       possiblepointy(j, :) = dy(j) - dy2;
       j = j + 1;
       
end
 
%If both of the differences are close to 0, then it's an intersection
while mass <= 1000 && o <= 1000
           
    if abs(possiblepointx(mass, o)) < .1 && abs(possiblepointy(mass, o)) < .1
    
        %Factor out the non-existing data points
        if dy(o) ~= 0 && dy2(o) ~= 0
           
            %Add an additional intersection point
            k = k + 1;
            
            %Add to the total the average of the target intersection points
            totalx = totalx + dx2(o);
            totaly = totaly + dy2(o);
            totalt = totalt + o;
 
        end
        
    end
    
    %Move to the next row
    mass = mass + 1;
    
    %Move to the next column and go back to row 1 every 1000 points
    if mass == 1000
        
        o = o + 1;
        mass = 1;
        
    end
end
 
%Determine the time necessary to launch the interceptor using target
%launcher data
 
%Determine the mean intersection points using target data
intersectionx = totalx / k;
intersectiony = totaly / k;
ttarget = totalt / k;
intersection = [intersectionx, intersectiony];
 
%Find interceptor intersection point
tinterceptor = find(abs(intersectionx - dx) < .1, 1, 'first');
 
%Find difference in times
 
sectowait = (ttarget - tinterceptor) / 100;
 
%Display information on when to shoot the interceptor
toc;
disp(['Fire the interceptor after ', num2str(sectowait), ' second(s) to intercept the missile at ', num2str(intersectionx), ' meters on the x-axis and ', num2str(intersectiony), ' meters on the y-axis.']);
 
%Plotting
%Interceptor
plot(dx, dy);
 
hold on
 
%Target
plot(dx2, dy2);
 
%Intersection
plot(intersectionx, intersectiony, 'k-o');
 
%Extra plotting stuff
xlim([-30, 70]);
ylim([.1, 100]);
legend('Interceptor', 'Target');
xlabel('X displacement in meters');
ylabel('Y displacement in meters');
title('Intersection of Target and Interceptor');
