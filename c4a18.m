%% 作业4-18
%
% by Dr. Guan Guoqiang @ SCUT on 2022-3-18

%% 初始化
clear
% 工质性质
Rg = 2.077e3; cv = 3.116e3; % [J/kg-K]
% 弹簧参数
k = 900; % 弹性系数 [N/m]
F = @(x)k*x; % 弹性力 [N]
x0 = 0.3; % 自由长度 [m]
A = 1e-3; % 活塞面积 [m2]

%% 闭口系
% 初态
p1 = 0.14e6; V1 = 1e-4; T1 = 40+273.15;
m = p1*V1/Rg/T1;
x1 = 0.25;
% 终态
syms p2 V2 T2 V
assume(T2>0)
assume(p2>0)
eos = p2*V2/T2 == p1*V1/T1;
dU = m*cv*(T2-T1);
X = (V-V1)/A; % 活塞运动距离与工质体积的关系
p = F(x0-x1+X)/A; % 闭口系工质压力 = 弹簧的弹性力
ebe = dU == -int(p,V,V1,V2);
st2 = p2 == subs(p,V,V2);
% 联立求解313.15
sol = solve([eos,ebe,st2],[p2,V2,T2]);
T2 = eval(sol.T2);
V2 = eval(sol.V2);
p2 = eval(sol.p2)/1e6;
% 过程熵变
dS = m*cv*(log(T2)-log(T1))+Rg*(log(V2)-log(V1));

%% 输出
fprintf('终态温度和压力分别为%.1fK和%.3fMPa\n',T2,p2)
fprintf('过程熵变为%.1fJ/kg-K\n',dS)