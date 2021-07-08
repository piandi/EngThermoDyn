%% 教材例9-3
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/16

clear
[T2a,T4a] = calcT(12)

function [T2a T4a] = calcT(pi)
syms p v T

% 工质性质
kappa = 1.4; cp = 1.005;
Rg = cp-cp/kappa;

% 状态1
p1 = 100; T1 = 300;
v1 = Rg*T1/p1;

% 经可逆绝热压缩到状态2
p2 = pi*p1;
v2 = eval(solve(p1*v1^kappa == p2*v^kappa));
T2 = p2*v2/Rg;
% 不可逆压缩
eta_C = 0.85;
T2a = T1+(T2-T1)/eta_C;

% 经可逆等压升温到状态3
p3 = p2; T3 = 1600;
v3 = Rg*T3/p3;

% 经可逆绝热膨胀到状态4
p4 = p1;
v4 = eval(solve(p3*v3^kappa == p4*v^kappa));
T4 = p4*v4/Rg;
% 不可逆膨胀
eta_T = 0.88;
T4a = T3-eta_T*(T3-T4);

% 压气机单位功耗
wC = -cp*(T2a-T1);
% 燃气轮机单位工质的做功量
wT = -cp*(T4a-T3);
% 单位工质的净功
wnet = wT+wC;
% 工质的质量流率
P = 100e3;
Qm = P/wnet;
% 热效率
eta_t0 = wnet/(cp*(T3-T2a));

% 采用回热后进燃烧室前工质温度为
sigma = 1;
T7 = eval(solve(sigma == (T-T2a)/(T4a-T2a)));
% 吸热量
q1 = cp*(T3-T7);
eta_t1 = wnet/q1;

end