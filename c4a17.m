%% 课后作业4-18
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/21

%% 初始化
clear
syms v T Q dm
% 工质性质
cv = 0.718; Rg = 0.286;
kappa = (cv+Rg)/cv;
% 初态
p1 = 2000; T1 = 400;
m = 2;
v1 = Rg*T1/p1;

%% 过程变化
% A和B气室联通且导热，即两室热力始终保持平衡，故以A和B气室整体建立绝热闭口系
% 外加对系统做功，体积变化为0
W = -40;
w = W/m;
T2 = eval(solve(cv*(T-T1) == -w));
v2 = v1;
p2 = Rg*T2/v2;
% 系统熵变
dS = m*(cv*log(T2/T1)+Rg*log(v2/v1));

%% 输出
fprintf('终态空气的温度和压力分别为%.2fK和%.1fkPa\n',T2,p2)
fprintf('系统熵变为%.4fkJ/K\n',dS)

%% 拓展问题
syms Q W m dm T2 T1 cv
% 假定外界对A气室做功使A室中部分气体流到B室，令从A室流到B室的工质量为dm
% 对于始终在A室中工质建立闭口系，其中放热量为Q
dUa = Q-W == (m/2-dm)*cv*(T2-T1);
% 对于终态在B室中工质建立闭口系
dUb = -Q == (m/2+dm)*cv*T2-(dm*cv*T1+m/2*cv*T1);
% 联立求解
eq1 = simplify(dUa+dUb);
eq2 = simplify(lhs(eq1)-rhs(eq1)) == 0;
% 输出
disp('已知外界做功量W、初态温度T1和工质cv，可通过解下方程求得T2')
disp(eq2)


