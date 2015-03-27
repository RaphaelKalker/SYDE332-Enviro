classdef SEIR
    %Assumes c to be a column
    %             pop = c(1);
    %             S   = c(2);
    %             E   = c(3);
    %             I   = c(4);
    %             R   = c(5);
    %             flux = c(6);

    properties (Constant)
    end

    methods (Static)
        function result = swapCells(c1,c2)

            %Determine diffusion of S,E,I,R individuals
            r1 = randsample(1:4, c1(6), true, [c1(2)/c1(1), c1(3)/c1(1), c1(4)/c1(1), c1(5)/c1(1)]);
            r2 = randsample(1:4, c2(6), true, [c2(2)/c2(1), c2(3)/c2(1), c2(4)/c2(1), c2(5)/c2(1)]);
            rsamples = [r1' r2'];

            SEIR_vals = zeros(4,2);

            %Each cell
            for i = 1:nargin
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

            result = [c1, c2];

        end
    end

end
