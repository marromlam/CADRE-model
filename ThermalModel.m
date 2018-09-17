function [ T ] = ThermalModel( tspan, EA, p, LoSs )
%function [ T ] = ThermalModel( tspan, EA, p, LoSs )
%   This function constitutes the thermal model of the satellite. From the 
%   heats generated by lighting, data transmission and issued by the 
%   Stefan-Boltzmann law, it calculates the temperature of the satellite 
%   for each step of time.
%
%       IN:     tspan       - time vector
%               EA          - exposed area
%               p           - communication power
%               LoSs        - line-of-sight Satellite-Sun
%
%       OUT:    T           - temperature (at given time)


%% Parameters

  AT    = 0.38;                                         % m2 
  m     = 4*0.4 + 2;                                    % kg
  cp    = 600*8 + 2000*4;                               % J/(kg K)
  q     = 1.36e3;                                       % W/m2
  alpha = 0.90;                                         % adim
  epsi  = 0.67;                                         % adim
  c     = 299792458;                                    % m/s
  k     = 1.3806488e-23;                                % J/K
  h     = 6.62606957e-34 ;                              % J/s
  sigma = (2*pi^5*k^4)/(15*c^2*h^3);                    % SI
  T0    = 273;
 
  
%% Module

  Qcom = @(t) vec2fun(t,tspan,0.8*p*LoSs);              % W
  Qin  = @(t) vec2fun(t,tspan,(alpha*q*AT.*EA));        % W
  Qout = @(x) epsi*sigma*AT*x^4;                        % W
  f = @(t,x) (Qin(t) + Qcom(t) - Qout(x))/(m*cp);
  [ ~, T ] = ode15s(@(t,x) f(t,x) , tspan, T0);


end