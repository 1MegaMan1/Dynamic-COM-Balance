%% dynamics_dp.m
% *Summary:* Implements ths ODE for simulating the double pendulum 
% dynamics, where an input torque can be applied to both links, 
% f1:torque at inner joint, f2:torque at outer joint
%
%    function dz = dynamics_dp(t, z, f1, f2)
%
%
% *Input arguments:*
%
%		t     current time step (called from ODE solver)
%   z     state                                                    [4 x 1]
%   f1    (optional): torque f1(t) applied to inner pendulum
%   f2    (optional): torque f2(t) applied to outer pendulum
%
% *Output arguments:*
%   
%   dz    if 4 input arguments:      state derivative wrt time
%         if only 2 input arguments: total mechanical energy
%
%   Note: It is assumed that the state variables are of the following order:
%         dtheta1:  [rad/s] angular velocity of inner pendulum
%         dtheta2:  [rad/s] angular velocity of outer pendulum
%         theta1:   [rad]   angle of inner pendulum
%         theta2:   [rad]   angle of outer pendulum
%
% A detailed derivation of the dynamics can be found in:
%
% M.P. Deisenroth: 
% Efficient Reinforcement Learning Using Gaussian Processes, Appendix C, 
% KIT Scientific Publishing, 2010.
%
%
% Copyright (C) 2008-2013 by
% Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen.
%
% Last modified: 2013-03-08

function dz = dynamics_dp(t, z, f1, f2)
%% Code
m1 = 0.5;  % [kg]     mass of 1st link
m2 = 0.5;  % [kg]     mass of 2nd link
b1 = 0.0;  % [Ns/m]   coefficient of friction (1st joint)
b2 = 0.0;  % [Ns/m]   coefficient of friction (2nd joint)
l1 = 0.5;  % [m]      length of 1st pendulum
l2 = 0.5;  % [m]      length of 2nd pendulum
g  = 9.82; % [m/s^2]  acceleration of gravity
I1 = m1*l1^2/12;  % moment of inertia around pendulum midpoint (1st link)
I2 = m2*l2^2/12;  % moment of inertia around pendulum midpoint (2nd link)
dt =.1;
persistent time;

if isempty(time)
    time=0.0;
end

if (t == 0) & (abs(z(1)-2.5) < 0.3) & (abs(z(2)) < 0.3) & (abs(z(3)) < 0.1) & (abs(z(4)) < 0.1) 
    time = 0.0
else
    if t == 0 
        time = time+dt;
    end
end    
    
 %if nargin == 4 % compute time derivatives

 % A = [l1^2*(0.25*m1+m2) + I1,      0.5*m2*l1*l2*cos(z(3)-z(4));
 %      0.5*m2*l1*l2*cos(z(3)-z(4)), l2^2*0.25*m2 + I2          ];
 % b = [g*l1*sin(z(3))*(0.5*m1+m2) - 0.5*m2*l1*l2*z(2)^2*sin(z(3)-z(4)) ...
 %                                                       + f1(t)-b1*z(1);
 %      0.5*m2*l2*(l1*z(1)^2*sin(z(3)-z(4))+g*sin(z(4))) + f2(t)-b2*z(2)];
  %x = A\b;

  dz = zeros(4,1);
  dz(1)=(1/dt)*((3*cos((time+t)*5) - f2(t)) - z(1));
  dz(2)=(1/dt)*(f2(t) - z(2));
  dz(3)=(1/dt)*((.6*sin((time+t)*5)+0 - z(4)+dt*z(2)+0.5*dt*(f2(t) - z(2))) - z(3));
  dz(4)=z(2);
end
