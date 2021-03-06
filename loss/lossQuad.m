%% lossQuad.m
% *Summary:* Compute expectation and variance of a quadratic cost 
% $(x-z)'*W*(x-z)$
% and their derivatives, where $x \sim N(m,S)$
%
%
%  function [L, dLdm, dLds, S, dSdm, dSds, C, dCdm, dCds] = lossQuad(cost, m, S)
%
%
%
% *Input arguments:*
%
%    cost
%      .z:     target state                                              [D x 1]
%      .W:     weight matrix                                             [D x D]
%    m         mean of input distribution                                [D x 1]
%    s         covariance matrix of input distribution                   [D x D]
%
%
% *Output arguments:*
%
%   L               expected loss                                  [1   x    1 ]
%   dLdm            derivative of L wrt input mean                 [1   x    D ]
%   dLds            derivative of L wrt input covariance           [1   x   D^2] 
%   S               variance of loss                               [1   x    1 ]
%   dSdm            derivative of S wrt input mean                 [1   x    D ]
%   dSds            derivative of S wrt input covariance           [1   x   D^2]    
%   C               inv(S) times input-output covariance           [D   x    1 ]   
%   dCdm            derivative of C wrt input mean                 [D   x    D ]  
%   dCds            derivative of C wrt input covariance           [D   x   D^2]  
%
% Copyright (C) 2008-2013 by
% Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen.
%
% Last modified: 2013-05-30
%
%% High-Level Steps
% # Expected cost
% # Variance of cost
% # inv(s)* cov(x,L)

function [L, dLdm, dLds, S, dSdm, dSds, C, dCdm, dCds] = lossQuad(cost, m, S)
%% Code
D = length(m); % get state dimension

% set some defaults if necessary
if isfield(cost,'W'); W = cost.W; else W = eye(D); end
if isfield(cost,'z'); z = cost.z; else z = zeros(D,1); end

% 1. expected cost
L = S(:)'*W(:) + ((z-m)'*W*(z-m)); 

% 1a. derivatives of expected cost
if nargout > 1
  dLdm = 2*(m-z)'*W; % wrt input mean
  dLds = W';         % wrt input covariance matrix
end

% 2. variance of cost
if nargout > 3
  S = trace(W*S*(W + W')*S) + (z-m)'*(W + W')*S*(W + W')*(z-m);
  if S < 1e-12; S = 0; end % for numerical reasons
end

% 2a. derivatives of variance of cost
if nargout > 4
  % wrt input mean
  dSdm = -(2*(W+W')*S*(W+W)*(z-m))'; 
  % wrt input covariance matrix
  dSds = W'*S'*(W + W')'+(W + W')'*S'*W' + (W + W')*(z-m)*((W + W')*(z-m))'; 
end

% 3. inv(s) times IO covariance with derivatives
if nargout > 6
    C = 2*W*(m-z);
    dCdm = 2*W;
    dCds = zeros(D,D^2);
end
