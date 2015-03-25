classdef Infection
    properties (Constant)
        a = .5; %inflection rate
        b = .3; %recovery rate
        S = 1; % Susceptible
        I = 1; %infected
        R = 1; %recovered
        S0 = .99
        I0 = .1;
        aR = 0;
        t0 = 0;
        tf = 100;
    end
    
    methods (Static)
        function plotODE45()
            [T,Y] =ode45(@solve_SIR,[0 50],[99,1,10]);
            plot(T,Y(:,1),T,Y(:,2),T,Y(:,3));
            legend('S','I','R');
        end
    end
    
end


% y(1) = S
% y(2) = I
% y(3) = R
function f = solve_SIR(t,y)
    a = Infect.a; b = Infect.b;
    f = zeros(3,1);
    f(1) = -a*y(1)*y(2);
    f(2) = a*y(1)*y(2)-b*y(2);
    f(3) = b*y(2); 
end


