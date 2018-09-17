function [ Pcom, SoC ] = BatteryModel( tspan, T , Psol, LoSg, p )
%function [ Pcom, SoC ] = BatteryModel( tspan, T , Psol, LoSc, p )
%   This function calculates the percentage of charge that remains in the 
%   battery and has imposed conditions on the state of the battery (because
%   not all Matlab optimization functions allow restrictions to be 
%   included), so a penalty function is written.
% 
%       IN:     tspan       - time vector
%               T           - temperature
%               Psol        - solar power
%               d           - line-of-sight Satellite-Station
%               p           - transmitter power (from previous iteration)
%
%       OUT:    Pcom        - transmitter power
%               SoC         - battery's state-of-charge


%% Parameters

  P0     = 2;                                           % W
  Q      = 2.900;                                       % A h
  Q      = Q*12/pi;
  lambda = log(1/1.1^5);                                % adimensional
  T0     = 293;                                         % K
  SoC0   = 0.8;


%% Model

  P  = Psol - P0 - p.*LoSg;                             % W 
  fP = @(t) vec2fun(t,tspan,P); 
  fT = @(t) vec2fun(t,tspan,T);
  V  = @(SoC,T) (3+(exp(SoC)-1)/(exp(1)-1)) * (2-exp(lambda*(T-T0)/T0));

  f  = @(x,t) (fP(t)/Q) * (1/V(x,fT(t)));  
  [ ~, SoC ] = ode15s(@(t,y) f(y,t) , tspan, SoC0); 
  dlmwrite('SoC.txt',SoC0-SoC(end),'-append')

% Constraints
  if (~isempty(find(SoC<0.2, 1))) || (~isempty(find(SoC>1, 1))) || ...
     (p > 25) || (abs(SoC(end) - SoC0) > 0.01)
    Pcom = p*exp(-1000*abs( SoC0-SoC(end) ));
  else
    Pcom = p;
  end
 
 
end