%% 2020级课测4-12
%
% by Dr. Guan Guoqiang @ SCUT on 2022-3-7

%% 初始化
clear
syms V
% 环境状态
p0 = 100e3; % [Pa]
% 工质性质
Rg = 259.8; % [J/kg-K]
cv = 662; % [J/kg-K]

%% 闭口系过程1-2
% 初态
p1 = p0+10e3; T1 = 45+273.15; V1 = 0.3;
m = p1*V1/Rg/T1;
% 终态
syms T2 V2
% 等压过程
p2 = p1;
% 传热量
Q = 40e3; % [J]
% 工质能量状态变化
dU = m*cv*(T2-T1);
% 做功量
W12 = int(p1,V,V1,V2);
% 能量平衡方程
ebe = dU == Q-W12;
% 状态方程
eos = p2*V2 == m*Rg*T2;
% 联立平衡方程和状态方程求V2和T2
sol = solve([ebe eos],[V2 T2]);
V2 = eval(sol.V2); T2 = eval(sol.T2);
W12 = eval(subs(W12,V2)); % [J]

%% 闭口系过程2-3
% 初态
% 终态
p3 = p0+15e3; T3 = 45+273.15;
V3 = m*Rg*T3/p3;
% 多变过程
syms n
n = eval(solve(p2*V2^n == p3*V3^n,n));
W23 = eval(int(p2*V2^n/V^n,V,V2,V3));

%% 输出
fprintf('过程做功量为%.1fkJ\n',(W12+W23)/1000)
