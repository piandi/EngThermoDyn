%% 课后作业2-8
%
% by 关国强 @ 华南理工大学，2020/03/05
%
clear;
syms x p;
pb = 0.1e6; A = 0.08; k = 400e2;
%% 以气缸中的空气为研究对象建立闭口系
% 加热前系统状态：p1 V1 T1
p1 = 0.1013e6; V1 = 0.008; T1=273.15+17;
Rg = 8.3145/29e-3; cv = 0.718e3;
m = p1*V1/T1/Rg;
% 加热前力平衡：气缸活塞重力 = (系统绝压p1-气压pb)*活塞面积A
mg = (p1-pb)*A;
% 加热后力平衡：气缸活塞重力+弹簧弹力（kx） = (系统绝压p2-气压pb)*活塞面积A
p2 = 0.15e6;
fbalance = mg+k*x == (p2-pb)*A;
xval = eval(solve(fbalance,x));
% 加热后系统状态：p2 V2(x) T2(p2,V2)-理想气体
V2 = V1+A*xval;
T2 = p2*V2/(m*Rg);
% 能量平衡：吸热量=闭口系能量变化+膨胀做功量
dU = m*cv*(T2-T1);
W = eval(int((mg+k*x)+pb*A,x,0,xval));
Q = dU+W;
%% 输出结果
fprintf('ANSWER: Input heat Q = %.2e J\n',Q)