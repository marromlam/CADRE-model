% This script takes [Dd] = SatFullModel(x) as a function and optimizes it 
% (minimizes -Dd) with 3 different algorithms: fmincon, fminsearch and ga. 
% Finally, a table of the results is constructed. As the fmincon algorithm 
% needs a seed near the final solution, it is provided next to the one that
% returns the genetic algorithm.


%% Clearing and starting values

  ! rm DesignVariables.txt
  ! rm SoC.txt
  clear all; clc; close all; format long

% From a GA 51 generation (7 hours) optimization this parameters are 
% obtained
  phi0   =   2.08;                       % angle (rad) - from   -pi to   pi
  theta0 =   1.04;                       % angle (rad) - from -pi/2 to pi/2
  alpha0 =   0.9;                        % angle (rad) - from     0 to pi/2
  Pcom0  =  23.3;                        % power (W)   - from     0 to   25

  x0 = [phi0, theta0, alpha0, Pcom0];                        % initial seed
  lb = [-pi,   -pi/2,      0,     0];                        % lower bounds
  ub = [+pi,   +pi/2,   pi/2,    25];                        % upper bounds

% Results from last full optimizacion (these will be overwritten if this 
% file is run)
% fmincon  -0.877136088928825   1.079701220321464   1.047132129442534  14.998887838431132
  x_gb  =  0; f_gb  =  0; t_gb  =  0;
  x_ngb =  0; f_ngb =  0; t_ngb =  0;
  x_ga  =  0; f_ga  =  0; t_ga  =  0;


%% Optimization routines

% Gradient-based optimization  [ FMINCON ]
  clear options
  options = optimoptions('fmincon');
  options = optimoptions(options,'Display', 'iter');
  options = optimoptions(options,'UseParallel', true);
  options = optimoptions(options,'OptimalityTolerance', 1e-8);
  tic
  [x,f,exitflag,output,lambda,grad,hessian] = fmincon(@(x) -SatFullModel(x), x0,[],[],[],[],lb,ub,[],options)
  x_gb = x'; f_gb = round(f);
  t_gb = toc;
  ! mv DesignVariables.txt FMINCON_DesignVariables.txt
   

% Non-gradient-based optimization  [ FMINSEARCH ]
  clear options
  options = optimset('Display','iter');
  options = optimset(options,'TolX',1e-3);
  options = optimset(options,'TolFun',1e-2);
  options = optimset(options,'UseParallel', true);
  tic
  [x,f] = fminsearch(@(x) -SatFullModel(x), x0,options);
  x_ngb = x'; f_ngb = round(f);
  t_ngb = toc;
  ! mv DesignVariables.txt FMINSEARCH_DesignVariables.txt
  
% Genetic algorithm  [ GA ]
  clear options
  options = optimoptions('ga');
  options = optimoptions(options,'PopulationSize', 40);
  options = optimoptions(options,'Display', 'iter');
  options = optimoptions(options,'FunctionTolerance', 1e-1);
  options = optimoptions(options,'UseParallel', true);
  tic
  [x,f] = ga(@(x)-SatFullModel(x),4,[],[],[],[],lb,ub,[],[],options);
  x_ga = x'; f_ga = round(f);
  t_ga = toc; 
  ! mv DesignVariables.txt GENETIC_DesignVariables.txt
  
  
  
%% Table of results

  ParameterResults = table(x_gb,x_ngb,x_ga,...
                   'VariableNames',{'fmincon','fminsearch','ga'},... 
                   'RowNames',{'phi';'theta';'alpha';'Power'})
  FunctionResults  = table([f_gb,t_gb]',[f_ngb,t_ngb]',[f_ga,t_ga]',...
                   'VariableNames',{'fmincon','fminsearch','ga'},... 
                   'RowNames',{'Data Downloaded';'time (seconds)'})

