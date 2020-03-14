%% 作业 3-17（第5版）/3-19（第4版）
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-14
%
%% 初始化
clear;
%% 以绝热刚性容器中工质为闭口系
% 工质性质
cp = 1005; Rg = 8.3145/29e-3;
% 假定工质空气为理想气体
syms p V T m
EOS = p*V == m*Rg*T;
cv = cp-Rg;
% 内能定义
U = m*cv*T;
%% 初态
% A室中的空气
V_A1 = 0.5; p_A1 = 250e3; T_A1 = 300;
% 代入EOS求得工质质量
m_A1 = eval(solve(subs(EOS, [p V T], [p_A1 V_A1 T_A1]), m));
% B室中的空气
V_B1 = 1; p_B1 = 150e3; T_B1 = 1000;
% 代入EOS求得工质质量
m_B1 = eval(solve(subs(EOS, [p V T], [p_B1 V_B1 T_B1]), m));
% 系统内能
U1 = eval(subs(U,[m T], [m_A1 T_A1])+subs(U,[m T], [m_B1 T_B1]));
%% A室和B室在刚性容器中绝热混合
Q = 0; W = 0;
% 由dU = Q-W得
dU = 0; 
U2 = U1;
m_A2 = m_A1; m_B2 = m_B1;
%% 终态
% A室和B室的空气混合均匀达到相同的状态
% 系统内能
T2 = eval(solve(U2 == eval(subs(U,m,m_A2)+subs(U,m,m_B2)), T));
V2 = V_A1+V_B1;
m2 = m_A2+m_B2;
p2 = eval(solve(subs(EOS, [m V T], [m2 V2 T2]), p));
%% 系统熵变
% 系统熵变 = 室A空气的熵变+室B空气的熵变
% ds(v,T) = cv/T dT + Rg/v dv = cp/T dT - Rg/p dp
% 室A空气的熵变
dS_A =  m_A1*(cp*log(T2/T_A1)-Rg*log(p2/p_A1));
% 室B空气的熵变
dS_B =  m_B1*(cp*log(T2/T_B1)-Rg*log(p2/p_B1));
dS = dS_A+dS_B;
%% 输出结果
fprintf('T2 = %.1f K, p2 = %.1f kPa, dS = %.1f J/K\n', T2, p2/1e3, dS)