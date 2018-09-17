function [ Dd, data ] = DataModel( tspan, angles, LoSg, d, Pcom )
%function [ Dd, data ] = DataModel( tspan, angles, LoSg, d, Pcom )
%   This function calculates the amount of data transmitted to the station 
%   on the ground by the satellite in a tspan time interval. The function 
%   uses the bit-rate to calculate the data rate transmitted per second, 
%   and then the ode is integrated.
% 
%       IN:     tspan       - time vector
%               angles      - position over Earth surface (at given time)
%               LoSg        - line-of-sight Satellite-Station
%               d           - distance Satellite-Station
%               Pcom        - transmitter power
%
%       OUT:    Dd          - data downloaded (fully integrated)
%               data        - data downloaded at given time


%% Parameters

  step   = tspan(2)-tspan(1);
  tfac   = 1.375098708313976e+04;                       % s/rad
  PHI    = angles(:,1); THETA  = angles(:,2);           % rad

  Gt    = TransmitterGain(PHI,THETA);                   % dB
  c     = 299792458;                                    % m/s
  Gr    = 12.9;                                         % dB
  Ll    = 2.0;                                          % dB
  f     = 437*1e6;                                      % Hz
  k     = 1.3806488e-23;                                % J/K
  Ts    = 500;                                          % K
  SNR   = 5.0;                                          % dB
  eta   = 0.2;                                          % adiml


%% Model

  cte  = ((c^2*Gr*Ll)/(16*pi^2*f^2*k*Ts*SNR));
  Br   = cte .* ((eta*Pcom*Gt)./(d.*d)) .*abs(LoSg);    % Gb/rad
  Dd = trapz(tspan,Br)/tfac;                            % Gb
  data = cumsum(Br*step)/tfac;
  

end