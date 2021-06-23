%% 向体积为1升的真空钢瓶中缓慢充入氮气。已知环境压力和温度分别为100kPa和298.15K，当钢瓶表压为150kPa时切换充入氧气，求表压升至200kPa时的瓶内气体总质量为____kg（注意保留4位有效数字）
%
% by Dr. Guan Guoqiang @ SCUT on 2021/6/7

% 工质性质
Rg1 = 8.3145/14;
Rg2 = 8.3145/32;

% 已知条件
V = 1e-3; % 单位：m3
T0 = 298.15; % 单位：K
p0 = 100; % 单位：kPa
p1 = 150+p0;
p2 = 200+p0;

% 充入氮气的质量
m1 = p1*V/Rg1/T0;

% 求再充入氧气后的总质量
syms m m2 Rg
eq1 = m == m1+m2;
eq2 = Rg == m1/m*Rg1+m2/m*Rg2;
eq3 = p2*V == m*Rg*T0;
sol = solve([eq1 eq2 eq3], [m m2 Rg]);
fprintf('气瓶总质量为%.4gkg\n',eval(sol.m))
