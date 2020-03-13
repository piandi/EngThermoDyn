%% 作业3-13
%
% Dr. GUAN, Guoqiang @ SCUT on 2020-03-13
%
clear;
%% 以理想气体工质氩气为闭口系
% 气体性质（查教材附表2）
Rg = 208.1; % 数值均为SI（下同）
cv = 0.312e3;
% 假定工质氩气为理想气体
syms p V T m
EOS = p*V == m*Rg*T;
%% 初态
p1 = 0.6e6; T1 = 600; m1 = 5; 
% 代入理想气体状态方程得到体积
V1 = eval(solve(subs(EOS, [p T m], [p1 T1 m1]), V));
%% 过程
% 已知过程内能变化为零，对于理想气体内能变化与系统的温度变化成正比
T2 = T1;
%% 终态
V2 = 3*V1; m2 = m1;
% 代入理想气体状态方程得到压力
p2 = eval(solve(subs(EOS, [V T m], [V2 T2 m2]), p));
%% 计算熵变
% ds(v,T) = cv/T dT + Rg/v dv
dS = m1*(cv*log(T2/T1)+Rg*log(V2/V1));
%% 输出
fprintf('T2 = %.1f K, p2 = %.3f MPa, dS = %.1f J/kg-K\n', T2, p2/1e6, dS)