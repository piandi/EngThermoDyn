%% 作业7-4
% 初始化
global logs
logs = struct([]); % 日志变量，记录计算过程
% 定义喷管进口处的工质状态
S1.Name = 'Air_PG'; S1.cp = 1005; S1.kappa = 1.4;
S1.Pressure = 2e6; S1.Temperature = 273.15+27; 
S1.Velocity = 0.0;
% 设定工质性质计算模型
Method.Property = SetMethod(S1);
% 计算滞止性质
S0 = StagnantProp(S1, Method);
% 计算临界性质
S0 = CriticalProp(S0, Method);
pc = S0.CriticalProp.p;
Tc = S0.CriticalProp.T;
vc = S0.CriticalProp.v;
cfc = S0.CriticalProp.cf;
p0 = S0.StagnantProp.p;
T0 = S0.StagnantProp.T;
kappa = S0.kappa;
Rg = S0.Rg;
% 确定出口压力
pb = 1.5e6; % 背压
if pb < pc
    cf2 = cfc;
    p2 = pc;
else
    p2 = pb;
end
% 计算出口温度
S2 = S0;
S2.Pressure = p2;
T2 = T0*(p0/p2)^((1-kappa)/kappa);
S2.Temperature = T2;
% 计算出口比体积
S2.SpecVolume = Rg*T2/p2;
% 计算出口流量
A2 = 10e-4;
S2.Velocity = cfc;
S2.Mass = 1/S2.SpecVolume*S2.Velocity*A2;
% 显示结果
fprintf('Critical pressure:         %.4e Pa\n', S2.CriticalProp.p);
fprintf('Nozzle outlet velocity:    %.1f m/s\n', S2.Velocity);
fprintf('Nozzle outlet flowrate:    %.2f m3/s or %.2f kg/s \n', ...
        A2*S2.Velocity, A2*S2.Velocity/S2.SpecVolume);
fprintf('Nozzle outlet temperature: %.2f K\n', S2.Temperature);
fprintf('Nozzle outlet density:     %.1f kg/m3\n', 1/S2.SpecVolume);
% 输出日志
% Setlog('', 2);