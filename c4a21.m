%% 作业4-21
%
% by Dr. Guan Guoqiang @ SCUT on 2022-3-19

%% 初始化
clear
% 工质性质
Rg = 8.3145*32; cp = 0.92e3; % [J/kg-K]

%% 闭口系
% 初态
p1 = 0.7e6; V1 = 28e-3; T1 = 65+273.15;
m = p1*V1/Rg/T1;
% 终态
V2 = 2*V1;
T2 = T1;
p2 = p1*V1/V2;
% 过程熵变
dS = m*Rg*log(2);

%% 输出
fprintf('终态温度和压力分别为%.1fK和%.3fMPa\n',T2,p2/1e6)
fprintf('过程熵变为%.1fJ/kg-K\n',dS)