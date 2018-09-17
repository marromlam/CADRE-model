function [ Dd ] = SatFullModel( x )
%function [ Dd ] = SatFullModel( x )
%   This function couples the different modules of the satellite model. It 
%   depends on a single vector that involves the four design variables: the
%   two angles that fix the orbit, the fin angle and the communication 
%   power. The function returns only the data transmitted to the ground 
%   station. As some Matlab optimization algorithms do not have the possi-
%   bility of adding constraints, a penalty line is added by hand, to force
%   the angles to be in their range.
%
%       IN:     x           - design variables vector
%
%       OUT:    Dd          - data downloaded


%% Main Coupled Model

% Assign dependecies
  phip   = round(100*x(1))/100;           % max precision on longitude 0.01
  thetap = round(100*x(2))/100;            % max precision on latitude 0.01
  alpha  = round( 10*x(3))/10;             % max precision on fin angle 0.1
  p      = round( 10*x(4))/10;                 % max precision on power 0.1
  % phip = x(1); thetap = x(2); alpha  = x(3); p = x(4);   ( fmincon only )               
   
% Main model function with constraints
  if (abs(phip)>pi) || (abs(thetap)>pi/2) || (alpha>pi/2) || (alpha<0)
    Dd = 0;                                      % constraints about angles
  else
    t0 = 0; t = linspace(0,2*pi,50000)'; 
    [ angles ]     = OrbitModel( t,  t0, phip, thetap ); 
    [ LoSs ]       = fLoSs( t, angles(:,1), angles(:,2) );
    [ LoSg, d ]    = fLoSc( angles(:,1), angles(:,2) ); 
    [ ea ]         = CellModel( angles,  alpha, LoSs );
    [ T ]          = ThermalModel( t, ea, p, LoSs );
    [ Psol ]       = SolarModel(  ea, T ); 
    [ Pcom, ~ ]    = BatteryModel( t, T, Psol, LoSg, p ); 
    [ Dd,  ~ ]     = DataModel( t, angles, LoSg, d, Pcom ); 

%% Export data an plot functions
    
%%% Export main variables
%     dlmwrite('DesignVariables.txt',...
%     [(180/pi)*x(1:3),x(4),round(Dd)],'-append')
%     export_mat = [t, angles, ea, T, Psol, SoC, data];
%     csvwrite('results_fin.csv',export_mat)
    
  end

    
end