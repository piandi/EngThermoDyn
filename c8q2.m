%% “压气机的热力过程”课堂测验2参考答案
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/15

clear
syms p v T

% 用叶轮式压气机压缩空气（cp=1.004kJ/kg-K，cv=0.717kJ/kg-K）。假定压缩过程为可逆绝热压缩，压气机的进气温度和压力分别为298.2K和0.1MPa，求增压比为15时的理论功耗是多少kJ/kg
% 工质性质
cp = 1.004; cv = 0.717;
Rg = cp-cv; kappa = cp/cv;

% 初态
p1 = 100; T1 = 298.2;
v1 = Rg*T1/p1;

% 经历可逆绝热压缩到终态
p2 = 15*p1;
v2 = eval(solve(p1*v1^kappa == p2*v^kappa));
T2 = p2*v2/Rg;

% 压气机单位功耗
w = eval(int((p1/p)^(1/kappa)*v1,p,p1,p2));

% 输出
fprintf('压气机的理论功耗为%.4gkJ/kg\n',w)