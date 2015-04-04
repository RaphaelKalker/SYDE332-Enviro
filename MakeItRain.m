clear vars; clc; close all;

width = 10;
height = 10;
GRID = GridCell(1);

for j = 1:GRID.w
    for i = 1:GRID.h
        GRID.setValues([i,j], 500, 20, 15, 0, 10);
    end
end

figure(2);
GRID.setupPlot(gray);
hold off;
count = 1;
while(true)
    
    %update all of the SIR models with the forward euler method
    for j = 1:GRID.w
        for i = 1:GRID.h

            vals = GRID.getValues([i,j]);
            A = Infection.getFinalValues(vals(1), vals(2), vals(3), vals(4), vals(5));
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

    GRID.doPlanes();
    
    %required to not screw up scaling
    hold on;
    [handle, isSame] = GRID.drawMap();
    refreshdata(handle);
    pause(0.1);
    caxis([1 4]);
    hold off;
    
    %Check if condition all recovered has been reached
    if (isSame)
        return;
    end
    
    gcf = figure(2);
    
    set(gcf,'units','pixel');
    set(gcf,'position',[0,0,10000,5000]);
    set(gcf,'papersize',[10000,5000]);
    export_fig(gcf,strcat(num2str(count),'.png'));
    
    %print('-f2', count, '-dpng');
    
    count = count + 1;
    
end


