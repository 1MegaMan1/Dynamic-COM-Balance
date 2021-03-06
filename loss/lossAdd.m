%% lossAdd.m
% *Summary:* Utility function to add a number of loss functions together, each of which
% can be using a different loss function and operating on a different part of
% the state.
%
%       function [L, dLdm, dLds, S, dSdm, dSds, C, dCdm, dCds] = lossAdd(cost, m, s)
%
% *Input arguments:*
%
%   cost            cost struct
%      .fcn         @lossAdd - called to arrive here
%      .sub{n}      cell array of sub-loss functions to add together
%         .fcn      handle to sub function
%         .losi     indices of variables to be passed to loss function
%         .< >      all fields in sub will be passed onto the sub function
%      .expl        (optional) if present cost.expl*sqrt(S) is added to the loss
%
%    m         mean of input distribution                              [D x 1]
%    s         covariance matrix of input distribution                 [D x D]
%
% *Output arguments:*
%
%   L               expected loss                                  [1   x   1]
%   dLdm            derivative of L wrt input mean                 [1   x   D]
%   dLds            derivative of L wrt input covariance           [1   x   D^2] 
%   S               variance of loss                               [1   x   1]
%   dSdm            derivative of S wrt input mean                 [1   x   D]
%   dSds            derivative of S wrt input covariance           [1   x   D^2]    
%   C               inv(S) times input-output covariance           [D   x   1]   
%   dCdm            derivative of C wrt input mean                 [D   x   D]  
%   dCds            derivative of C wrt input covariance           [D   x   D^2]  
%
% Copyright (C) 2008-2013 by
% Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen.
%
% Last modified: 2013-03-05

function [L, dLdm, dLds, S, dSdm, dSds, C, dCdm, dCds] = lossAdd(cost, m, s)
%% Code

% Dimensions and Initializations
Nlos = length(cost.sub); D = length(m);
L = 0; S = 0; C = zeros(D,1); dLdm = zeros(1,D); dSdm = zeros(1,D);
dLds = zeros(D); dSds = zeros(D); dCdm = zeros(D); dCds = zeros(D,D^2);

for n = 1:Nlos                            % Loop over each of the sub-functions
  costi = cost.sub(n); i = costi.losi;    % slice
  
  % Call the sub loss function
  if nargout < 4                      % Just the expected loss & derivs
    [Li, Ldm, Lds] = costi.fcn(costi, m(i), s(i,i));
    
    L = L + Li;
    dLdm(i) = dLdm(i) + Ldm; dLds(i,i) = dLds(i,i) + Lds;
    
  else                                % Also loss variance and IO covariance
    [Li, Ldm, Lds, Si, Sdm, Sds, Ci, Cdm, Cds] = costi.fcn(costi, m(i), s(i,i));
    
    L = L + Li;
    S = S + Si + Ci'*s(i,:)*C + C'*s(:,i)*Ci; % V(a+b) = V(a)+V(b)+C(a,b)+C(b,a)
    
    if nargout > 4    % derivatives
      dLdm(i) = dLdm(i) + Ldm; dLds(i,i) = dLds(i,i) + Lds;
      
      Cis = Ci'*(s(i,:) + s(:,i)'); Cs = C'*(s(:,i) + s(i,:)');
      
      dSdm(i) = dSdm(i) + Sdm + Cs*Cdm; dSdm = dSdm + Cis*dCdm;
      dSds(i,i) = dSds(i,i) + Sds + reshape(Cs*Cds,length(i),length(i));
      dSds = dSds + reshape(Cis*dCds,D,D);
      dSds(i,:) = dSds(i,:)  + Ci*C'; dSds(:,i) = dSds(:,i) + C*Ci';
    end
    
    % Input - Output covariance update
    C(i) = C(i) + Ci;                  % must be after S and its derivatives
    
    ii = sub2ind2(D,i,i);
    dCdm(i,i) = dCdm(i,i) + Cdm;             % must be after dSdm & dSds
    dCds(i,ii) = dCds(i,ii) + Cds;
  end
end

% Exploration if required
if isfield(cost,'expl') && nargout > 3 && cost.expl ~= 0
  L = L + cost.expl*sqrt(S);
  dLdm = dLdm + cost.expl*0.5/sqrt(S)*dSdm;
  dLds = dLds + cost.expl*0.5/sqrt(S)*dSds;
end

function idx = sub2ind2(D,i,j)
% D = #rows, i = row subscript, j = column subscript
i = i(:); j = j(:)';
idx =  reshape(bsxfun(@plus,D*(j-1),i),1,[]);
