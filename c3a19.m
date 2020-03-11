%% 习题3-19（第5版）| 习题3-20（第4版）
clear;
syms a p v q;
% 以气缸中的工质建立闭口系?
% 已知过程前后的状态
T1 = 27+273.15; T2 = 327+273.15; p1 = 1e6; p2 = 1.5e6; m = 3;
% 已知工质性质
Rg = 0.260; cv = 0.658;
v1 = Rg*T1/p1; v2 = Rg*T2/p2; % 假定工质为理想气体
% 已知压力变化与体积变化成线性关系，即dp = a*dv+b
% 由于过程体积不发生变化时压力也不变，即dp(0) = 0，故b=0，所以dp = a*dv
% 故可由过程前后状态确定比例系数a
a = solve((p2-p1)==a*(v2-v1), a);
% 过程功: w = int(p, v, v1, v2)代入dv = dp/a
w = int(p/a, p, p1, p2);
% 内能
du = cv*(T2-T1);
% 应用封闭体系热力学第一定律计算吸热量
Q = m*solve(du == q-w, q);
fprintf('Exchanged heat is %.1f kJ\n', double(eval(Q)));