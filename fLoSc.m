function [ LoSc, npos ] = fLoSc(PHI,THETA)
%function [ LoSc, npos ] = fLoSc(PHI,THETA)
%   This function calculates whether the ground station and the satellite 
%   can communicate. For this, it is based on basic principles of geometry 
%   and calculates the scalar product of the position vector of the station
%   with the station-satellite position vector.
%
%       IN:     PHI         - azimutal angle at given time
%               THETA       - zenit angle at given time
%
%       OUT:    LoSc        - line-of-sight Satellite-Station
%               npos        - module distance Satellite-Station


%% Main function

% Earth radius and satellite height
  R0 =  281*1e3;                                        % m 
  RT = 6371*1e3;                                        % m 
  
% Sat and ground station position function vectors
  Rge = @(phi,theta)      RT.*[cos(theta).*cos(phi),...
                               cos(theta).*sin(phi),...
                               sin(theta)];
                           
  stationpos = Rge(-83.73*pi/180,42.28*pi/180);         % Ann Arbor Station
  %stationpos = Rge(0,-pi/2);                           % Antartica Station
  
  Rbg = @(phi,theta) (RT+R0).*[cos(theta).*cos(phi),...
                               cos(theta).*sin(phi),...
                               sin(theta)] - stationpos;
  
% Sat and ground station position vectors    
  rpos = Rbg(PHI,THETA);
  npos = sqrt( rpos(:,1).^2 + rpos(:,2).^2 + rpos(:,3).^2 );
  d    = rpos * transpose(stationpos);
  LoSc = (atan(100*(d - 0.1)) + pi/2)/pi;
  

end