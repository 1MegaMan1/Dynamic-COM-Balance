%% dynamics_pendubot.m
% *Summary:* Implements ths ODE for simulating the Pendubot 
% dynamics, where an input torque f can be applied to the inner link 
%
%    function dz = dynamics_pendubot(t,z,f)
%
%
% *Input arguments:*
%
%		t     current time step (called from ODE solver)
%   z     state                                                    [4 x 1]
%   f     (optional): torque f(t) applied to inner pendulum
%
% *Output arguments:*
%   
%   dz    if 3 input arguments:      state derivative wrt time
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

function dz = dynamics_pendubot(t,z,f)
%% Code
m1 = 0.5;  % [kg]     mass of 1st link
m2 = 0.5;  % [kg]     mass of 2nd link
b1 = 0.1;  % [Ns/m]  coefficient of friction (1st joint)
b2 = 0.1;  % [Ns/m]  coefficient of friction (2nd joint)
l1 = 0.5;  % [m]      length of 1st pendulum
l2 = 0.5;  % [m]      length of 2nd pendulum
g  = 9.82; % [m/s^2]  acceleration of gravity
I1 = m1*l1^2/12;  % moment of inertia around pendulum midpoint (inner link)
I2 = m2*l2^2/12;  % moment of inertia around pendulum midpoint (outer link)

%if nargin == 3 % compute time derivatives

%  A = [l1^2*(0.25*m1+m2) + I1,      0.5*m2*l1*l2*cos(z(3)-z(4));
 %      0.5*m2*l1*l2*cos(z(3)-z(4)), l2^2*0.25*m2 + I2          ];
 % b = [g*l1*sin(z(3))*(0.5*m1+m2) - 0.5*m2*l1*l2*z(2)^2*sin(z(3)-z(4))...
%                                                        + f(t) - b1*z(1);
 %      0.5*m2*l2*( l1*z(1)^2*sin(z(3)-z(4)) + g*sin(z(4)) )    - b2*z(2)];
 % x = A\b;

  dz = zeros(4,1);
  dz(1) = f(t) - z(3);%x(1)
  dz(2) = z(4);%x(2)
  dz(3) = z(1);
  dz(4) = z(2);

%else % compute total mechanical energy
%  dz = m1*l1^2*z(1)^2/8 + I1*z(1)^2/2 + m2/2*(l1^2*z(1)^2 ...
%    + l2^2*z(2)^2/4 + l1*l2*z(1)*z(2)*cos(z(3)-z(4))) + I2*z(2)^2/2 ...
%    + m1*g*l1*cos(z(3))/2 + m2*g*(l1*cos(z(3))+l2*cos(z(4))/2);
end