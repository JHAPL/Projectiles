function paths = getPaths(time, startingX, startingZ, startingVX, startingVZ)

%%% ============================== Inputs ============================= %%%
% time - The times at which to get the paths of the objects
% startingX - The initial X position of the threat (interceptor at 0,0)
% startingZ - The initial Z position of the threat (interceptor at 0,0)
% startingVX - The initial X velocity of the threat
% startingVZ - The initial Z velocity of the threat
%%% ============================= Outputs ============================= %%%
% paths - A structure with 2 fields: interceptor and threat
% Both are matrices of length time and width 4 of the paths 
% The columns are vx, vz, x, z
% Each row corresponds to a time


%Defining variables
voInterceptor = 20;
angleInterceptor = pi / 4;

%Define parameters for threat structure
threatParams.mass = 1.134;
threatParams.area = 0.05067;
threatParams.drag = 0.47;
threatIC = [startingVX,startingVZ, startingX, startingZ];

%Define parameters for interceptor structure
interceptorParams.mass = 0.0427;
interceptorParams.area = 0.0025652;
interceptorParams.drag = 0.47;
interceptorIC = [-voInterceptor * cos(angleInterceptor),voInterceptor * sin(angleInterceptor),0,0];

%Differential equations solver calculates the X velocities, Z velocities,
%X position, and Z position. Stored in an array 'Y'
[tInterceptor,YInterceptor] = ode45(@(t,Y) trajectory(t,Y,interceptorParams), time, interceptorIC);
[tThreat,YThreat] = ode45(@(t,Y) trajectory(t,Y,threatParams), time, threatIC);


paths.interceptor = YInterceptor;
paths.threat = YThreat;
end

