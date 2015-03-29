classdef GridCell < dynamicprops
    %             pop = c(1);
    %             S   = c(2);
    %             E   = c(3);
    %             I   = c(4);
    %             R   = c(5);
    %             flux = c(6);
    
    properties
        population = 300;
        S = 100;
        E = 0;
        I = 0;
        R = 0;
        f = 10;
        
        pt = [];
        w = 0;
        h = 0;
    end
    
    methods
        %creates an array of GridCell
        function obj = GridCell(width, height)
            obj.w = width;
            obj.h = height;
            obj.pt = zeros(width, height, 6);
        end
        
        function GC = setValues(GC, coord, Suc, Exposed, Infected, Recovered, flux)
            
            index = sub2ind([GC.h, GC.w, 6], coord(1), coord(2), 1);
            
            GC.pt(index) = Suc + Exposed + Infected + Recovered;
            GC.pt(index + 1*(GC.w * GC.h)) = Suc;
            GC.pt(index + 2*(GC.w * GC.h)) = Exposed;
            GC.pt(index + 3*(GC.w * GC.h)) = Infected;
            GC.pt(index + 4*(GC.w * GC.h)) = Recovered;
            GC.pt(index + 5*(GC.w * GC.h)) = flux;
        end

        % population, Succeptible, exposed, Infected, Recovered, Flux
        function z = getValues(GC, coord)
            
            %check cordinates incase we are outside of the grid for flux
            %transitions
            % i -> rows (height), j -> cols (width)
            if (coord(1) > GC.h || coord(1) < 0)
                z = [];
                return;
            end
            
            if (coord(2) > GC.w || coord(2) < 0)
                z = [];
                return;
            end
            
            index = sub2ind([GC.h, GC.w, 6], coord(1), coord(2), 1);
            
            Pop = GC.pt(index);
            Suc = GC.pt(index + 1*(GC.w * GC.h)) ;
            Exposed = GC.pt(index + 2*(GC.w * GC.h));
            Infected = GC.pt(index + 3*(GC.w * GC.h));
            Recovered = GC.pt(index + 4*(GC.w * GC.h));
            flux = GC.pt(index + 5*(GC.w * GC.h));
            z = [Pop, Suc, Exposed, Infected, Recovered, flux];
        end
        
        function GC = setupPlot(GC, colorScheme)
           caxis([1 3])
           colorbar;
           colormap(colorScheme);
        end
        
        function handle = drawMap(GC)
            %Sooooooo, this takes the S,I,R elements (ignore the E for now)
            %and flattens into single [GridSize, GridSize, 3] matrix. Then
            %find the maximum S,I, or R value in each grid cell
            %Put it into a pcolor thing
            M = cat(3,GC.pt(:,:,2),GC.pt(:,:,3),GC.pt(:,:,5));
            [Q, INDEX] = max(M, [], 3);
            handle = pcolor(INDEX);
        end
        
        
        
        function GC = swapCells(GC, c1,c2, position)

            %Determine diffusion of S,E,I,R individuals
            r1 = randsample(1:4, c1(6), true, [c1(2)/c1(1), c1(3)/c1(1), c1(4)/c1(1), c1(5)/c1(1)]);
            r2 = randsample(1:4, c2(6), true, [c2(2)/c2(1), c2(3)/c2(1), c2(4)/c2(1), c2(5)/c2(1)]);
            rsamples = [r1' r2'];

            SEIR_vals = zeros(4,2);

            %Each cell
            for i = 1:2
                %Each random sample row
                for j=1:4
                    SEIR_vals(j,i) = sum(rsamples(:,i) == j);
                end
            end

            %Out's
            c1(2:5) = c1(2:5) - SEIR_vals(:,1);
            c2(2:5) = c2(2:5) - SEIR_vals(:,2);

            %In's
            c1(2:5) = c1(2:5) + SEIR_vals(:,2);
            c2(2:5) = c2(2:5) + SEIR_vals(:,1);
            
            % If negative transition, force that person to go back
            n1 = find(c1(2:5) < 0);
            n2 = find(c2(2:5) < 0);
            if any(n1)
                val = c1(1+n1);
                c1(1+n1) = 0;
                c2(1+n1) = c2(1+n1) + abs(val);
            end
            if any(n2)
                val = c2(1+n2);
                c2(1+n2) = 0;
                c1(1+n2) = c1(1+n2) + abs(val);
            end

            GC.setCells([c1, c2], position);

        end
        
        function GC = setCells(GC, cells, position)
            GC.setValues(position(1,:), cells(2,1), cells(3,1), cells(4,1), cells(5,1), cells(6,1));   
            GC.setValues(position(2,:), cells(2,2), cells(3,2), cells(4,2), cells(5,2), cells(6,2));
        end
       
    end
    
end




