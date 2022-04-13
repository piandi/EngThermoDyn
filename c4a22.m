%% 作业4-22
%
% by Dr. Guan Guoqiang @ SCUT on 2022-3-19

%% 初始化
clear
% 工质性质
Rg = 287; cv = 717; cp = 1004; % [J/kg-K]
kappa = cp/cv;

%% 开口系CV1
% 初态
p1 = 3e6; T1 = 296;
v1 = Rg*T1/p1;
syms V
assume(V~=0)
m1 = p1*V/Rg/T1;
% 终态
p2 = 0.3e6;
syms T2
m2 = p2*V/Rg/T2;
m = m1-m2; % 流出空气质量 [kg]
% % 能量平衡方程
% ebe1 = m1*cv*(T2-T1) == -m*Rg*T2;
% % 解得
% valT2 = eval(solve(ebe1,T2));
valT2 = (p1/p2)^((1-kappa)/kappa)*T1;

%% 开口系CV2
% 透平出口
pb = 0.1e6;
% 可逆绝热膨胀
Tb = (p2/pb)^((1-kappa)/kappa)*valT2;
% 能量平衡方程
% ebe2 = -150e3 == m*cp*(Tb-T2);
ebe2 = m1*cv*(Tb-T1)+m1*Rg*Tb == m2*cv*(Tb-T2)+m2*Rg*Tb-150e3;
% 解得
% valV = eval(subs(solve(ebe2,V),T2,valT2));
valV = eval(solve(subs(ebe2,T2,valT2)));

%% 输出
fprintf('气瓶体积至少要%.3gm3\n',valV)