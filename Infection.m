classdef Infection
    properties (Constant)
        a = 0.55; %infection rate
        c = 0.1; %1/c = average latent infection time
        b = .10; %recovery rate
        E0 = .1;
        t0 = 0;
        tf = 3;
    end
    
    methods (Static)
        function finalVals = getFinalValues(POP, S0, E0, I0, R0)
            [T,Y] = ode45(@solve_SIR, [Infection.t0 Infection.tf], [S0/POP E0/POP I0/POP R0/POP]);
            Infection.plotODE(T, Y);
            finalVals = [Y(end,1)*POP, Y(end,2)*POP, Y(end,3)*POP, Y(end,4)*POP];
        end
        
        function plotODE(T, Y)
            plot(T,Y(:,1),T,Y(:,2),T,Y(:,3),T,Y(:,4));
            legend('Susceptible', 'Exposed','Infected','Recovered');
        end
    end
end

function f = solve_SIR(t,y)
    a = Infection.a; 
    b = Infection.b;
    c = Infection.c;
    
    f = zeros(4,1);
    f(1) = -a*y(1)*y(3); %S' = -bSI
    f(2) = a*y(1)*y(3) - c*y(2); %E' = bSI - cE
    f(3) = c*y(2)-b*y(3); %I' = cE - bI
    f(4) = b*y(3); %R = bI
end




