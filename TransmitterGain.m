function [ Gt ] = TransmitterGain( PHI, THETA )
%function [ Gt ] = TransmitterGain( PHI, THETA ) 
%   The gain of the satellite depends on its position on the surface of the
%   Earth. This dependence is given by a matrix that must be interpolated 
%   depending on the position of the satellite as a function of time.
% 
%       IN:     PHI         - azimutal angle at given time
%               THETA       - zenit angle at given time
%
%       OUT:    Gt          - gain


%% Main Function

% Load matrix
  M = csvread('TransmitterGain.csv');

% Native x y axes CSV gain
  xvec = 2*pi*(0:1:size(M,2)-1)/(size(M,2)-1) - pi;  
  yvec = pi*(0:1:size(M,1)-1)/(size(M,1)-1) - pi/2;

% 2D interp 
  Gt = interp2(xvec,yvec,M,PHI,THETA);


end