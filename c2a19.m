%% 作业2-19
%
% by Dr. Guan Guoqiang @ SCUT on 2022-3-7

%% 初始化
clear
syms V m2 T2
p0 = 0.1e6; % [Pa]

%% 工质性质
u = @(T)657*T; % [J/kg]
h = @(T)917*T;
Rg = (0.917-0.657)*1000; kappa = 917/657;

%% 
% 初态
V1 = 0;
p1 = 0;
% 终态
V2 = 0.008; % [m3]
p2 = 0.15e6; % [Pa]
% 流入工质
ps = 14e6; Ts = 17+273.15;
vs = Rg*Ts/ps;
% 膨胀功=系统克服大气压力做功
W = p0*(V2-V1);
% 开口系能量平衡
eq = m2*0.657e3*T2 == m2*0.917e3*Ts-W;
% 状态方程
eos = m2*Rg*T2 == p2*V2;
sol = solve([eq,eos],[m2,T2]);
%% 输出
fprintf('充入气体质量为%.3gkg，其温度为%.4gK\n',eval(sol.m2),eval(sol.T2));