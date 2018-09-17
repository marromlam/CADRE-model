function [ EA ] = CellModel( angles, alpha, LoSs )
%function [ EA ] = CellModel( angles, alpha, LoSs )
%   This function is the model of the shadow that is produced by the solar 
%   lighting of the satellite and whose area corresponds to the one that 
%   generates solar energy. The Shadow function is generated with a 
%   projection operator in Mathematica, after several approximations.
%
%       IN:     angles      - position over Earth surface (at given time)
%               alpha       - fin angle 
%               LoSs        - line-of-sight Satellite-Sun
%
%       OUT:    EA          - exposed area


%% Parameters

  PHI = angles(:,1); THETA = angles(:,2);               % rad
  alpha = alpha + pi/2;                                 % rad (correction)
  AT    = 0.38;                                         % m2 


%% Model

% Shadow function. Depends on sat position over Earth (PHI,THETA)
  Shadow = @(phi,theta,alpha) 1e-6.*(...
            60000.*sqrt(cos(theta).^2.*cos(phi).^2)+ ...
            20000.*sqrt(sin(theta).^2)+ ...
            30000.*sqrt((cos(alpha).*cos(theta).*cos(phi)-...
            1.*sin(alpha).*sin(theta)).^2)+...
            30000.*sqrt((cos(alpha).*cos(theta).*cos(phi)+...
            sin(alpha).*sin(theta)).^2)+...
            60000.*sqrt(cos(theta).^2.*sin(phi).^2)+...
            30000.*sqrt((sin(alpha).*sin(theta)-...
            1.*cos(alpha).*cos(theta).*sin(phi)).^2)+...
            30000.*sqrt((sin(alpha).*sin(theta)+...
            cos(alpha).*cos(theta).*sin(phi)).^2)... 
                                    );
% Evaluating shadow model
  EA = Shadow(PHI,THETA,alpha); EA = (EA/AT).*LoSs;


end