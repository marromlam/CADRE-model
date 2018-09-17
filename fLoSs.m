function [ LoSs ] = fLoSs(tspan, PHI,THETA)
%function [ LoSs ] = fLoSs(tspan, PHI,THETA)
%   This function calculates whether the Sun and the satellite see each
%   other. For this, it is based on basic principles of geometry 
%   and calculates the scalar and cross product of the position vector of
%   the Sun with the satellite position vector.
%
%       IN:     tspan       - time vector
%               PHI         - azimutal angle at given time
%               THETA       - zenit angle at given time
%
%       OUT:    LoSs        - line-of-sight Satellite-Sun


%% Main function

% Earth radius and satellite height
  R0 =  281*1e3;                                        % m 
  RT = 6371*1e3;                                        % m 
  
% Sat and Sun  position function vectors
  Rse = @(phi,theta)       1.*[cos(theta).*cos(phi-tspan),...
                               cos(theta).*sin(phi-tspan),...
                               sin(theta).*ones(size(tspan))];

  Rbe = @(phi,theta) (RT+R0).*[cos(theta).*cos(phi),...
                               cos(theta).*sin(phi),...
                               sin(theta)] ;
                           
  rse = Rse(0,pi/2);                                  % Sun at t=0 position
  rbe = Rbe(PHI,THETA);
  
% Computing geometrical variables  
  d = rse(:,1).*rbe(:,1) + rse(:,2).*rbe(:,2) + rse(:,3).*rbe(:,3);
  c = cross(transpose(rse),transpose(rbe));
  c = transpose(sqrt( c(1,:).^2 + c(2,:).^2 + c(3,:).^2 )) - RT;  
  
  LoSd = (atan(100*(d - 0.1)) + pi/2)/pi;
  LoSc = (atan(100*(c - 0.1)) + pi/2)/pi;
  LoSs = LoSd  + (LoSd==0).*LoSc;
  

end