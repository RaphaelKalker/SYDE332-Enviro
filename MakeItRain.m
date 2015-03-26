clear vars; clc; close all;

S0 = .99
I0 = .1;
R0 = 0;
A = Infection.plotODE45(S0, I0, R0)
disp('MAKING IT RAIN');