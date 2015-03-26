classdef Infection
    properties (Constant)
        a = .5; %inflection rate
        b = .3; %recovery rate
        S = 1; % Susceptible
        I = 1; %infected
        R = 1; %recovered
%         S0 = .99
%         I0 = .1;
%         R0 = 0;
        E0 = .1;
        t0 = 0;
        tf = 100;
    end
    
    methods (Static)
        function ode = plotODE45(S0, I0, R0)
%             a = Infection.a; 
%             b = Infection.b; S0 = Infection.S0
            [T,Y] = ode45(@solve_SIR, [Infection.t0 Infection.tf], [S0 I0 R0]);

            plot(T,Y(:,1),T,Y(:,2),T,Y(:,3));
            legend('Susceptible','Infected','Recovered');
            ode = [Y(end,1), Y(end,2), Y(end,3)];
        end
    end
    
end

% y(1) = S
% y(2) = I
% y(3) = R
function f = solve_SIR(t,y)
    a = Infection.a; b = Infection.b;
    f = zeros(3,1);
    f(1) = -a*y(1)*y(2);
    f(2) = a*y(1)*y(2)-b*y(2);
    f(3) = b*y(2); 
end


