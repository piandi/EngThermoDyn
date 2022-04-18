%% 第287页：习题(8-11)
%
% by Dr. Guan Guoqiang @ SCUT on 2022/4/15

%% 初始化
clear
% 工质特性：理想气体空气
air = MaterialPG;
air.cp = 1.004; air.cv = 0.717;
kappa = air.kappa;
Rg = air.Rg;
cp = air.cp;
cv = air.cv;

%% 
% 压缩前状态
s1 = StatePG;
s1.Material = air;
s1.p = 100; s1.T = 20+273.15;
Qm = 1200/60; % [kg/s]
% 理想压缩后状态
s2 = StatePG;
s2.p = 600;
[~,wt,~,~] = Polytropic(kappa,s1,s2);
% 实际功耗
wc = wt/0.85;
dh = -wc;
% 计算压气机实际出口温度
syms T2
T2 = eval(solve(cp*(T2-s1.T) == dh,T2));
% 实际压缩后状态
s2a = StatePG;
s2a.Material = air;
s2a.p = s2.p; s2a.T = T2;
% 计算不可逆压缩的熵增
ds = cv*log(s2.T/s2a.T)+Rg*log(s2.v/s2a.v);
dS = Qm*ds;
% 计算㶲损
T0 = 293.15;
I = T0*dS;

%% 输出
fprintf('（1）压气机出口温度及功耗分别为%.4g K和%.4g kW\n',T2,Qm*abs(wc))
fprintf('（2）过程熵增率及㶲损分别为%.4g kW/K和%.4g kW\n',dS,I)