%% “压气机的热力过程”课堂测验2参考答案
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/16

clear

% 获得压气机热效率计算式
c9s3
eta = subs(eta_t,[epsilon, lambda, rho], [12,1.5,2.5]);
fun = @(x)eval(subs(eta,kappa,x));
% 画出绝热指数对压气机热效率的影响曲线
kappa = 1.1:0.05:1.4;
plot(kappa,fun(kappa))
xlabel('$\kappa$','Interpreter','latex')
ylabel('$\eta_t$','Interpreter','latex')