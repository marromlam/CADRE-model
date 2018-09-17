function [ angles ] = OrbitModel( t, t0, phi_plane, theta_plane )
%function [ angles ] = OrbitModel( t, t0, phi_plane, theta_plane )
%   This function calculates the angles on Earth surface in which the sate-
%   llite is found for each time discretization. The function needs the 
%   time vector, the origin of time, and the angles that determine the 
%   orbital plane.
%
%       IN:     t           - time vector
%               t0          - time origin (it is a scalar number)
%               phi_plane   - one of the angles that determine the orbit 
%                             plane, it varies from -pi to pi
%               theta_plane - one of the angles that determine the orbit
%                             plane, it varies from -pi/2 to pi/2
%
%       OUT:    angles      - matrix of spherical coordinates angles, 
%                             (phi, theta), with satellite position
%                             projection over Earth surface at everytime.


%% Parameters

  R0 = 1;
  w = 24*60/90;                                          % rev/day  T = 90'
  
  
%% Model

% Orbit parametric function
  OrbitFunction = @(phi, theta)   R0.* ...
    [+cos(w*(t-t0)).*cos(phi-t) - sin(w*(t-t0)).*cos(theta).*sin(phi-t),...
     +cos(w*(t-t0)).*sin(phi-t) + sin(w*(t-t0)).*cos(theta).*cos(phi-t),...
                                + sin(w*(t-t0)).*sin(theta)];

% Calc position over time
  Orbit  = OrbitFunction(phi_plane,theta_plane);
  THETA  = real(asin(Orbit(:,3)));
  PHI    = real(sign(Orbit(:,2)).*acos(Orbit(:,1)./cos(asin(Orbit(:,3)))));
  angles = [PHI,THETA];

  
end