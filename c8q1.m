%% “压气机的热力过程”课测1参考答案
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/13

%% 采用活塞绝热压缩气体。将100kPa、25C理想气体（cp=1.004kJ/kg-K、cv=0.785kJ/kg-K）绝热压缩到0.4MPa的功耗为多少kJ/kg
% 工质性质
cp = 1.004; cv = 0.785; kappa = cp-cv; Rg = cp-cv;
% 初始状态
p1 = 100; T1 = 25+273.15; v1 = Rg*T1/p1;
% 可逆绝热变化到终态
syms p v T
p2 = 400;
v2 = eval(solve(p1*v1^kappa == p2*v^kappa));
% 可逆压缩功耗
w = eval(int(p1*(v1/v)^kappa,v,v1,v2));
% 输出
fprintf('可逆绝热压缩过程的功耗为%.4gkJ/kg\n',abs(w))

%% 用活塞式压气机压缩空气（cp=1.004kJ/kg-K，cv=0.717kJ/kg-K）。假定压缩过程为可逆绝热压缩，压气机的进气温度和压力分别为298.2K和0.1MPa，求增压比为5时的理论功耗是多少kJ/kg
% 工质性质
cp = 1.004; cv = 0.717; Rg = cp-cv; kappa = cp/cv;
% 初态
p1 = 100; T1 = 298.2; v1 = Rg*T1/p1;
% 终态
p2 = 5*p1;
syms p v T
v2 = eval(solve(p1*v1^kappa == p2*v^kappa));
T2 = p2*v2/Rg;
% 压气机的技术功
wT = -eval(int(v1*(p1/p)^(1/kappa),p,p1,p2));
% 输出
fprintf('压气机理论功耗为%.4gkJ/kg\n',abs(wT))