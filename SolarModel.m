function [ Psol ] = SolarModel( ea, T )
%function [ Psol ] = SolarModel( ea, T )
%   The solar power generated is calculated under the Shockley model, that 
%   is, a slight modification of the ideal diode. As the satellite is 
%   considered as an all-solar-panel one, then certain corrections are 
%   necessary per area: AT/At factors.
% 
%       IN:     EA          - exposed area
%               T           - temperature
%
%       OUT:    Psol        - solar power


%% Parameters

  AT    = 0.38;                                         % m2 
  At    = 2.66e-3;                                      % m2
  k     = 1.3806488e-23;                                % J/K
  Isc0  = 0.453.*AT/At;                                 % A
  Isat  = 2.809e-12*AT/At;                              % A
  n     = 1.35;                                         % adim
  q     = 1.60217657e-19;                               % C
  Rsh   = 40;                                           % ohm
 

%% Model

% Diode ideal model
  VT    = n*k*T/q;
  Isc   = ea.*Isc0;
  fI    = @(V) Isc - Isat*(exp(V./VT)-1) - V/Rsh;

% Eval model
  Vspan = linspace(0,2,300);
  Ispan = ea.*fI(Vspan);
  Psol  = 1.0.*max(Ispan.*Vspan,[],2);


end