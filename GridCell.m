classdef GridCell < dynamicprops
    %GRIDCELL Summary of this class goes here
    %   Detailed explanation goes here
    
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
            obj.pt = zeros(width * height, 6);
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
            
            index = sub2ind([GC.h, GC.w, 6], coord(1), coord(2), 1);
            
            Pop = GC.pt(index);
            Suc = GC.pt(index + 1*(GC.w * GC.h)) ;
            Exposed = GC.pt(index + 2*(GC.w * GC.h));
            Infected = GC.pt(index + 3*(GC.w * GC.h));
            Recovered = GC.pt(index + 4*(GC.w * GC.h));
            flux = GC.pt(index + 5*(GC.w * GC.h));
            z = [Pop, Suc, Exposed, Infected, Recovered, flux];
        end
       
        
    end
    
end

