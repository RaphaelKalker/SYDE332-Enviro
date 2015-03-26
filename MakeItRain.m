
    clear vars; clc; close all;

    GRID = GridCell(10,10);
    
    for j = 1:GRID.w
        for i = 1:GRID.h
            GRID.setValues([i,j], i, j, 1, 1, 1,1);
        end
    end
    
    Infection.plotODE45();
