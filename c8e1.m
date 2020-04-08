%% 教材（第5版）例8-1
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-08
%
%% 初始化
clear;
syms p v T
% 假定工质为理想气体
Rg = 0.287e3; n = 1.35; 
eos = p*v == Rg*T;

%% 顺次表达状态点性质
% 状态1性质（未知值用符号变量表示）
p1 = 0.098e6; T1 = 17+273.15;
v1 = eval(subs(solve(eos, v), [p T], [p1 T1]));
syms m1
V1 = m1*v1;
%
% 状态2性质（未知值用符号变量表示）
syms p2 v2 T2 
% 通过1-2过程计算
% 1-2为多变过程导出其状态变化方程
syms dlnp dlnv dlnT
eq1 = dlnp + n*dlnv == 0; % 多变过程的微分形式
eq1a = subs(eq1, [dlnp,dlnv], [log(p2)-log(p1),log(v2)-log(v1)]);
% 应用eos于状态2
eq1b = subs(eos, [p v T], [p2 v2 T2]);
%
% 状态3性质（未知值用符号变量表示）
p3 = 0.35e6;
syms m3
% 通过2-3过程计算
% 2-3为等状态排气过程导出其状态变化方程
eq2 = p2 == p3;
%
% 联立求解
sol1 = solve([eq1a eq1b eq2], [p2 v2 T2]);
p2 = eval(sol1.p2);
v2 = eval(sol1.v2);
T2 = eval(sol1.T2);
%
v3 = v2;
V3 = m3*v3;

%% 其他条件
% 已知余容比sigma
sigma = 0.05;
eq3 = sigma == V3/(V1-V3);
% 已知气缸排气质量
m = 0.5;
eq4 = m1-m3 == m;
% 联立求解
sol2 = solve([eq3,eq4], [m1,m3]);
m1 = eval(sol2.m1);
m3 = eval(sol2.m3);

%% 输出
fprintf('Air in cylinder is %.4f kg\n', m1)
