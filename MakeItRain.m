clear vars; clc; close all;

GRID = GridCell(10,10);

for j = 1:GRID.w
    for i = 1:GRID.h
        GRID.setValues([i,j], i, j, 1, 1, 1);
    end
end



%update all of the SIR models with the ODE45 solver
for j = 1:GRID.w
    for i = 1:GRID.h
        
        vals = GRID.getValues([i,j]);
        A = Infection.plotODE45(vals(2), vals(3), vals(4), vals(5));
        vals(2) = A(1);
        vals(3) = A(2);
        vals(4) = A(3);
        vals(5) = A(4);
        GRID.setValues([i,j], vals(2), vals(3), vals(4), vals(5), vals(6));
    end
end
disp('MAKING IT RAIN');
