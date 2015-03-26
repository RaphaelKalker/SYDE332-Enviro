clear vars; clc; close all;

GRID = GridCell(10,10);

for j = 1:GRID.w
    for i = 1:GRID.h
        GRID.setValues([i,j], i, j, 1, 1, 1,1);
    end
end


S0 = .99
I0 = .1;
R0 = 0;
A = Infection.plotODE45(S0, I0, R0)
disp('MAKING IT RAIN');
