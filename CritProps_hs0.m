function [ pc, vc, Tc, wc ] = CritProps_hs0( h0, s0 )
%% Determine the critical properties of steam at high-speed flows
% Input stagnant properties h-s
% h0 - stagnant specific enthalpy [kJ/kg]
% s0 - stagnant specific entropy [kJ/kg-K]
% Output p-v-T properties at which the Mach number is 1
% pc - critical pressure [bar]
% vc - critical specific volume [m3/kg]
% Tc - critical temperature [C]
% wc - sound speed [m/s]
%
% Addons Depandancy
% This function requires the XSteam 
%
% by Guoqiang GUAN Dr. @ SCUT, 2019-6-11

%% 确定喉部性质（临界性质）
% Get the stagnant pressure [bar]
p0 = XSteam('p_hs', h0, s0);
% 设定喉部压力初值
pc = 0.5*p0;
sc = s0; % 假定流动为可逆绝热过程
eps = 1; 
% 迭代计算喉部压力使之满足计算精度
while eps > 0.01 % 迭代精度为相对偏差1%
    wc = XSteam('w_ps', pc, sc);
    kec = wc^2/2/1000;
    hc = h0-kec;
    pc_new = XSteam('p_hs', hc, sc);
    eps = abs((pc_new-pc)/pc_new);
    pc = pc_new;
end
% 喉部比体积和温度
vc = XSteam('v_ps', pc, sc);
Tc = XSteam('T_ps', pc, sc);
%
end

