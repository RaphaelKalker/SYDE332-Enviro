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
        
        wm;
        long = [];
        lat = [];
        mappingCoeff = [];
        
        pt = [];
        w = 0;
        h = 0;
    end
    
    methods
        %creates an array of GridCell
        function obj = GridCell(density)
                        
            %the map
            figure(3);
            
            obj.wm = worldmap('World');
            setm(obj.wm, 'Origin', [0 180 0]);
            setm(obj.wm, 'MapProjection', 'mercator');
            land = shaperead('landareas', 'UseGeoCoords', true);       
                        
            obj.lat = cat(2, land(2).Lat, land(3).Lat, land(5).Lat, land(9).Lat, land(11).Lat, land(22).Lat);
            obj.long = cat(2, land(2).Lon, land(3).Lon, land(5).Lon, land(9).Lon, land(11).Lon, land(22).Lon);
                        
            % cell per degree
            [Z, R] = vec2mtx(obj.lat, obj.long, density, [-90 90], [-180 180], 'filled');

            geoshow(obj.wm, cat(2,land(2), land(3), land(5), land(9), land(11), land(22)), 'Facecolor', [0.7,0.2,0.1]);
            
            obj.pt = repmat(Z,1,1,7);
            [obj.h, obj.w] = size(Z);
            obj.mappingCoeff = R;
        end
        
        function GC = setValues(GC, coord, Suc, Exposed, Infected, Recovered, flux)
            
            index = sub2ind([GC.h, GC.w, 7], coord(1), coord(2), 1);
            
            %you can't touch dis if you a water (2)
            if(GC.pt(index + 6*(GC.w * GC.h)) == 2)
                GC.pt(index + 1*(GC.w * GC.h)) = 0;
                GC.pt(index + 2*(GC.w * GC.h)) = 0;
                GC.pt(index + 3*(GC.w * GC.h)) = 0;
                GC.pt(index + 4*(GC.w * GC.h)) = 0;
                GC.pt(index + 5*(GC.w * GC.h)) = 0;
                GC.pt(index) = 0;
                return;
            end
            
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
           figure(2);
           caxis([1 4])
           colorbar;
           colormap(colorScheme);
        end
        
        function [handle,isSame] = drawMap(GC)
            %Sooooooo, this takes the S,I,R elements (ignore the E for now)
            %and flattens into single [GridSize, GridSize, 3] matrix. Then
            %find the maximum S,I, or R value in each grid cell
            %Put it into a pcolor thing
            figure(2);
            M = cat(3,GC.pt(:,:,2),GC.pt(:,:,3),GC.pt(:,:,5));
            [Q, INDEX] = max(M, [], 3);
            ANY = any(M, 3);
            INDEX = INDEX + ANY;
            handle = pcolor(INDEX);
            
            %We need to determine when to stop.
            %So check if INDEX has the same val but not filled with 1's
            %i.e. keep going if filled with susceptibles
            isSame = 0;
            if (max(max(INDEX)) == min(min(INDEX)) && min(min(INDEX)) ~= 1)
                isSame = 1;
            end
            result = [handle, isSame];
            
        end
        
        
        
        function GC = swapCells(GC, c1,c2, position)
            
            %don't swap the water cells around (flux has been set to zero
            %for it
            if(c1(6) == 0 || c2(6) == 0)
                return;
            end
            
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




