function estimate = kfilter(first, x, z, dt)

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

setGlobal();
global sigmaX sigmaZ;
global initialVXThreat initialVZThreat;
global Q;

if(first)
    
    %Simulated camera error for measurements
    
    R = zeros(2, 2);
    R(1, 1) = sigmaX^2;
    R(2, 2) = sigmaZ^2;
    
    %Measurement matrix
    H = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];
    
    
    %Initial guesses for position, velocity, and acceleration (meters based)
    startX = x;
    startVX = initialVXThreat;
    startAX = 0;
    startZ = z;
    startVZ = initialVZThreat;
    startAZ = -9.8;
    %Create a matrix to represent all initial values
    thetaLast = [startX; startVX; startAX; startZ; startVZ; startAZ];
    %Initial variance matrix
    pLast = zeros(6, 6);
    % pLast = 10^2*diag(ones(6,1));
    pLast(1,1) = sigmaX^2;
    pLast(2,2) = 5^2;
    pLast(3,3) = 3^2;
    pLast(4,4) = sigmaZ^2;
    pLast(5,5) = 5^2;
    pLast(6,6) = 3^2;
    
    estimate.time = Inf;
    estimate.theta = thetaLast;

else
   
    %Get the measured values, will be changed to take camera input later
    measurement = [x ; z];
    %Kalman filter
    %Get the state transformation matrix
    F = getFMatrix(dt);
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
    pLast = (eye(6) - K*H)*pPrediction;
    
    %Gets the estimate for how long until launch
    estimate.theta = thetaLast;
    estimate.time = getTimeEstimate(thetaLast);
    
end
end


function time = getTimeEstimate(theta)
global initialXInterceptor initialZInterceptor initialVXInterceptor initialVZInterceptor;
g = 9.8;
xThreat = theta(1);
zThreat = theta(4);
vXThreat = theta(2);
vZThreat = theta(5);

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
function F = getFMatrix(dt)

F = [1, dt, .5 * dt^2, 0, 0, 0; 0, 1, dt, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, dt, .5 * dt^2; 0, 0, 0, 0, 1, dt; 0, 0, 0, 0, 0, 1];

end
