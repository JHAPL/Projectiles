function f = trajectory(t, Y, parameters)

%%% ============================== Inputs ============================= %%%
% t - t is the time paramater, unused because the force is time invariant 
% Y - The variables to differentiate with respect to time
% parameters - The parameters of the object (mass, drag, area)
%%% ============================= Outputs ============================= %%%
% f - The derivatives of the Y variables
%A set of differential equations that describes the forces
%on the particle at any given point and velocity


%parameters is a structure that contains the fields below
mass = parameters.mass;
crossSectionalArea = parameters.area;
coefficentOfDrag = parameters.drag;

%Physical constants
density = 1.225; %of the air in kg/m^3
g = 9.8; %Acceleration due to gravity
c = crossSectionalArea * coefficentOfDrag * density / 2; %Calculation of
%the air resistance coefficiant

%Create a new matrix of the other sides of the derivative equations
%See work for more details and explanation on how the below equations were
%derived
f = zeros(4,1);


%Derivative of vx
f(1,1)= -c * sqrt(Y(1).^2 + Y(2).^2) * Y(1) / mass;
%Derivative of vy
f(2,1)= -c * sqrt(Y(1).^2 + Y(2).^2) * Y(2) / mass - g;
%Derivative of x
f(3,1)= Y(1);
%Derivative of z
f(4,1)= Y(2);
