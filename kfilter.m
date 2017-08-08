function estimate = kfilter(first, x, z, dt, dim)

%%% ============================== Inputs ============================= %%%
% first - A boolean on whether it is the first time
% the kalman filter is being run
% x - The measured x position
% z - The measured z position
% dt - The amount of time between this measurment and the last one
%%% ============================= Outputs ============================= %%%
% estimate - A structure containing 2 fields: time, the estimated amount of time until
% launch from the most recent measurement, and theta, the array containing
% the current estimate of the state (x, Vx, Ax, z, Vz, Az).

persistent thetaLast;
persistent pLast;
persistent R H;

global sigmaX sigmaZ;
global initialVXThreat initialVZThreat;

global interceptorParams;
global density;
global gravity;
global a_sigma;
global Sw


if(first)
    
    %Simulated camera error for measurements
    
    R = zeros(2, 2);
    R(1, 1) = sigmaX^2;
    R(2, 2) = sigmaZ^2;
    
    if(dim == 6)
        H = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];
    end
    if(dim == 4)
        H = [1, 0, 0, 0; 0, 0, 1, 0];
    end
    
    %Initial guesses for position, velocity, and acceleration (meters based)
    thetaLast = zeros(dim, 1);
    thetaLast(1) = x;
    thetaLast(2) = initialVXThreat;
    thetaLast(dim / 2 + 1) = z;
    thetaLast(dim / 2 + 2) = initialVZThreat;
    
    if(dim == 6)
        thetaLast(6) = -9.8;
    end
    
    
    %Initial variance matrix
    pLast = zeros(dim);
    % pLast = 10^2*diag(ones(6,1));
    if(dim == 6)
        pLast(1,1) = sigmaX^2;
        pLast(2,2) = 5^2;
        pLast(3,3) = 3^2;
        pLast(4,4) = sigmaZ^2;
        pLast(5,5) = 5^2;
        pLast(6,6) = 3^2;
    end
    if(dim == 4)
        pLast(1,1) = sigmaX^2;
        pLast(2,2) = 2*sigmaX^2/dt;
        pLast(3,3) = sigmaZ^2;
        pLast(4,4) = 2*sigmaZ^2/dt;
        
    end
    
    estimate.time = Inf;
    estimate.theta = thetaLast;
    
else
    
    %Get the measured values, will be changed to take camera input later
    measurement = [x ; z];
    %Kalman filter
    %Get the state transformation matrix
    
    
    if(dim == 4)
        F = getFMatrix4(dt);
        M = [dt^3/3 dt^2/2; dt^2/2 dt];
        Q = a_sigma^2*blkdiag(M,M);
        
    end
    
    if(dim == 6)
        F = getFMatrix6(dt);
        M = [dt^5 / 20, dt^4 / 8, dt^3 / 6;
            dt^4/8, dt^3 / 3, dt^2 / 2;
            dt^3 / 6, dt^2 / 2, dt];
        Q = Sw*blkdiag(M,M);
        %Q = 0.1 * eye(6);
    end
    
  
    %Predict new state values
    thetaPrediction = F * thetaLast;
    %Predict new variance values
    pPrediction = F * pLast * F' + Q;
    %Predicted measurement
    zPrediction = H * thetaPrediction;
    %Find measurement residual
    residual = measurement - zPrediction;
    %Finds kalman adjustments
    S = R + H * pPrediction * H';
    K = pPrediction * H' / S;
    %Find new predicted values of theta
    thetaLast = thetaPrediction + K * residual;
    %Find new predicted covariance values
    pLast = (eye(dim) - K*H)*pPrediction;
    
    %Gets the estimate for how long until launch
    estimate.theta = thetaLast;
    estimate.time = getTimeEstimate(thetaLast, dim);
    
end
end


function time = getTimeEstimate(theta, dim)
global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
g = 9.8;
xThreat = theta(1);
zThreat = theta(dim / 2 + 1);
vXThreat = theta(2);
vZThreat = theta(dim / 2 + 2);

a = vXThreat;
b = xThreat;
c = -g / 2;
d = vZThreat;
e = zThreat;


aThreat = c / a / a;
bThreat = d / a - 2 * b * c / a / a;
cThreat = c * b * b / a / a - d * b / a + e;

a = initialVXInterceptor;
b = initialXInterceptor;
c = -g / 2;
d = initialVZInterceptor;
e = initialZInterceptor;

aInterceptor = c / a / a;
bInterceptor = d / a - 2 * b * c / a / a;
cInterceptor = c * b * b / a / a - d * b / a + e;

a = aThreat - aInterceptor;
b = bThreat - bInterceptor;
c = cThreat - cInterceptor;


xCollision = (-b - sqrt(b * b - 4 * a * c)) / 2 / a;
tThreat = (xCollision - xThreat) / vXThreat;
tInterceptor = (xCollision - initialXInterceptor) / initialVXInterceptor;
time = tThreat - tInterceptor;

end
%This method retrieves the state transformation matrix for given time
%difference
function F = getFMatrix6(dt)

F = [1, dt, .5 * dt^2, 0, 0, 0; 0, 1, dt, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, dt, .5 * dt^2; 0, 0, 0, 0, 1, dt; 0, 0, 0, 0, 0, 1];

end


function F = getFMatrix4(dt)

F = [1, dt,  0,  0; 
     0,  1,  0,  0; 
     0,  0,  1, dt; 
     0,  0,  0,  1];

end