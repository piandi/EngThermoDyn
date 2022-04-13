%% 计算题1（2020毕业生重考“工程热力学”试卷）
%
% Dr. Guan Guoqiang @ SCUT on 2020/6/11
%

%% 顺次计算压缩空气制冷循环的各状态
% 过程1-2为绝热压缩，过程2-3为等压放热，过程3-4为绝热吸热,过程4-1为等压吸热
T1 = 290; % 单位[K]
syms p v T
eq3 = p*v == Rg*T;
syms p1 p2 T2
v1 = subs(solve(eq3, v),[p T],[p1 T1]);
v2 = subs(solve(eq3, v),[p T],[p2 T2]);
eq4 = p1*v1^kappa == p2*v2^kappa;
eq5 = p2/p1 == 5;
solve([eq4 eq5],T2)
