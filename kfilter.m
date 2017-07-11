function timeEstimate = kfilter(first, getTime, x, z, dt)
persistent thetaLast;
persistent pLast;
persistent lastEstimate;
persistent Q R H;
sigmaX = .5;
sigmaZ = .5;


if(first)
     %Process error matrix
    Q = .001 * diag(ones(6, 1)); %For now
    %Simulated camera error for measurements
    
    R = zeros(2, 2);
    R(1, 1) = sigmaX^2;
    R(2, 2) = sigmaZ^2;
    
    %Measurement matrix
    H = [1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0];
    
    lastEstimate = 1000;
    %Initial guesses for position, velocity, and acceleration (meters based)
    startX = x;
    startVX = 20 * cos(pi / 4);
    startAX = 0;
    startZ = z;
    startVZ = 20 * cos(pi / 4);
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
    %thetaLast
    %Gets the estimate for how long until launch
    if getTime
        timeEstimate = trajectorymodel(thetaLast(1), thetaLast(4), thetaLast(2), thetaLast(5), false);
        lastEstimate = timeEstimate;
    else
        timeEstimate = lastEstimate;
    end
    
end
end

%This method retrieves the state transformation matrix for given time
%difference
function F = getFMatrix(dt)

F = [1, dt, .5 * dt^2, 0, 0, 0; 0, 1, dt, 0, 0, 0; 0, 0, 1, 0, 0, 0;
    0, 0, 0, 1, dt, .5 * dt^2; 0, 0, 0, 0, 1, dt; 0, 0, 0, 0, 0, 1];

end
