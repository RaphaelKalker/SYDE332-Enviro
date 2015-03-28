clear vars; clc; close all;

GRID = GridCell(10,10);

for j = 1:GRID.w
    for i = 1:GRID.h
        GRID.setValues([i,j], 60, 15, 15, 0, 10);
    end
end

%update all of the SIR models with the ODE45 solver
% for j = 1:GRID.w
%     for i = 1:GRID.h
%         
%         vals = GRID.getValues([i,j]);
%         A = Infection.getFinalValues(vals(2), vals(3), vals(4), vals(5));
%         vals(2) = A(1);
%         vals(3) = A(2);
%         vals(4) = A(3);
%         vals(5) = A(4);
%         GRID.setValues([i,j], vals(2), vals(3), vals(4), vals(5), vals(6));
%     end
% end

%single test case
vals = GRID.getValues([i,j]);
A = Infection.getFinalValues(vals(1), vals(2), vals(3), vals(4), vals(5));

%Test swap cells function
NewCs = SEIR.swapCells([1,2,3,4,5,6]', [1,2,3,4,5,6]')

