%% 课后作业3-15
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/7

% 初始化
clear

% 假定工质CO2为理想气体
Rg = 0.1889; % 单位：kJ/kg-K
% 初始状态
p1 = 100; % 单位：kPa
T1 = 27+273.15; V1 = 0.8;
m = p1*V1/Rg/T1;
% 闭口系工质CO2从初态变化到终态
dS = 0.242; % 单位：kJ/K
ds = dS/m;
p2 = 100;
% 理想气体熵变计算
Calc_ds = @(T2)integral(@integralFun,T1,T2)-Rg*log(p2/p1);
% 求解积分方程使熵变为指定值
T2 = fzero(@(T2)Calc_ds(T2)-ds,T1);

% 输出结果
fprintf('终态温度为%.2fK\n',T2)

function out = integralFun(T)
    theta = T./1000;
    cp = 0.45+1.67*theta-1.27*theta.^2+0.39*theta.^3;
    out = cp./T;
end
