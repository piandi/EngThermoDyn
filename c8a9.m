%% 第287页：习题(8-9)
%
% by Dr. Guan Guoqiang @ SCUT on 2022/4/15

%% 初始化
clear
% 工质特性：理想气体空气
air = MaterialPG;
air.cp = 1.004; air.cv = 0.717;
kappa = air.kappa;
Rg = air.Rg;

%%
% 气缸参数
QV = 14/60; % [m3/s]
Vh = QV/0.95;
% 状态1
s1 = StatePG;
s1.Material = air;
s1.p = 100; s1.T = 273.15+21;
m = QV/s1.v; % [kg/s]
% 状态2
s2 = StatePG;
s2.p = 520;
[~,wt,~,~] = Polytropic(kappa,s1,s2);
% 余隙容积中残留空气状态
s3 = s2;
% 状态4
s4 = StatePG;
s4.p = 100;
Polytropic(kappa,s3,s4);
% 求余隙容积中残留空气质量mc
syms mc
mc = eval(solve(Vh-QV == mc*Rg*(s4.T/s4.p-s3.T/s3.p),mc));
% 余隙容积
V3 = mc*s3.v;

%% 输出
fprintf('（1）余容比为%.3g\n',V3/Vh)
fprintf('（2）压气机功耗为%.4g kW\n',abs(wt)*m)