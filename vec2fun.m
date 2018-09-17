function [ y ] = vec2fun( t, tspan, F )
%function [ y ] = vec2fun( t, tspan, F )
%   This function transforms a vector function that is given as tspan and F
%   vectors in a pseudo-analytic function y = f(t), so that y =F= f(tspan).
%   This is done by the Matlab spline function.

  y = spline(tspan,F,t);

end