%% 燃气轮机装置的定压加热实际循环
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/16

clear

kappa = 1.4; cp = 1.004; T1 = 298.2;

% 理想循环热效率
eta = @(pi)(1-1/pi^((kappa-1)/kappa));
% 循环净功
w = @(pi,tau)cp*T1*(tau-tau*pi^((1-kappa)/kappa)-pi^((kappa-1)/kappa)+1);

pi = 1:0.5:20;
tau = 2:5;
lineNames = cell(size(tau));
Xmax = zeros(size(tau));
Ymax = zeros(size(tau));
for i = 1:length(tau)
    X = pi;
    Y = arrayfun(@(x)w(x,tau(i))/cp/T1,pi);
    [Ymax(i),j] = max(Y);
    Xmax(i) = X(j);
    X(Y<0) = []; Y(Y<0) = [];
    plot(X,Y)
    xlabel('$\pi$','Interpreter','latex')
    ylabel('$\frac{w}{c_p T_1}$','Interpreter','latex')
    lineNames{i} = sprintf('$\\tau = %d$',tau(i));
    hold on
end
plot(Xmax,Ymax,'--o')
legend(lineNames,'Interpreter','latex','Location','best')
