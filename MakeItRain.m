clear vars; clc; close all;

width = 10;
height = 10;
GRID = GridCell(width,height);

for j = 1:GRID.w
    for i = 1:GRID.h
        GRID.setValues([i,j], i, j, 1, 1, 1);
    end
end


%update all of the SIR models with the ODE45 solver
for j = 1:GRID.w
    for i = 1:GRID.h
        
        vals = GRID.getValues([i,j]);
        A = Infection.getFinalValues(vals(2), vals(3), vals(4), vals(5));
        vals(2) = A(1);
        vals(3) = A(2);
        vals(4) = A(3);
        vals(5) = A(4);
        GRID.setValues([i,j], vals(2), vals(3), vals(4), vals(5), vals(6));
    end
end

%Allow Individuals to move around
for i = 1:GRID.h
    for j = 1:GRID.w
        pos = [i,j];
        posRight = [i,j+1];
        posBottom = [i+1, j];
        
        cell = GRID.getValues(pos);
        cellRight = GRID.getValues(posRight);
        cellBelow = GRID.getValues(posBottom);
        
        %only allow left-right swap if the j+1 column is defined
        if(~isempty(cellRight))
            %Let the people travel
            GRID.swapCells(cell', cellRight', [pos; posRight]);
        end
        
        %only allow top-bottom swap if the i+1 row is defined
        if(~isempty(cellBelow))
            %Let the people travel
            GRID.swapCells(cell', cellBelow', [pos; posBottom]);
        end
    end
end


%Test swap cells function
NewCs = SEIR.swapCells([1,2,3,4,5,6]', [1,2,3,4,5,6]')

