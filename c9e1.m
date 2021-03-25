%% 教材（第5版）例9-1
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-15
%

%% 初始化
clear

%% 定义数据结构
% InitState - (i struct) 初始状态的热力学基本性质
%          .p (double) 压力（国际单位，未声明下同）
%          .v (double) 比体积
%          .T (double) 温度
InitState = struct('p', [], 'v', [], 'T', []);
% Material  - (i struct) 理想气体物性
%          .Name (string) 物质名称
%          .MW (double) 分子量
%          .Rg (double) 质量气体常数
%          .cp (double) 定压比热
%          .cv (double) 定容比热
%          .kappa (double) 绝热指数
Material = struct('Name', "Air", 'MW', 28.97, 'Rg', 287, 'cp', 1.004e3, 'cv', 0.717e3, 'kappa', 1.4);
% Process   - (i struct) 过程特征参数定义
%          .n (double) 压缩、膨胀
%          .epsilon (double) 压缩比
%          .lambda (double) 定容增压比
%          .rho (double) 预膨胀系数
Process = struct('n', [], 'epsilon', [], 'lambda', [], 'rho', []);

%% 已知条件
% 萨巴德循环
opt = 0;
% 初态
InitState.p = 0.17e6;
InitState.T = 60+273.15;
% 定义萨巴德循环的特征参数
Process.n = Material.kappa; % 绝热压缩和膨胀
Process.epsilon = 14.5;
Process.lambda = 1.2; 
Process.rho = 1.2;
%
p3 = 10.3e6;
q1 = 900e3;
T0 = 20+273.15; % 环境温度

%% 过程计算
% 求解满足[p3 = 10.3MPa; q1 = 900kJ/kg]的定容增压比和预膨胀系数
% 设定定容增压比和预膨胀系数的初值
x0 = [Process.lambda Process.rho];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_p3_q1(x, InitState, Material, Process, opt), x0, options);
% 更新过程特征参数
Process.lambda = x(1); 
Process.rho = x(2);
% 计算循环热效率
output = PowerCycle_ICE(InitState, Material, Process, opt);
eta_t = 1-abs(output.q2)/output.q1;
% 计算吸热过程熵变
cp = Material.cp; Rg = Material.Rg;
p2 = output.properties.Pressure(2); p4 = output.properties.Pressure(4);
T2 = output.properties.Temperature(2); T4 = output.properties.Temperature(4);
s24 = cp*log(T4/T2)-Rg*log(p4/p2);
% 平均吸热温度
Tm = q1/s24;
% 吸热中的有效能量
ex = (1-T0/Tm)*q1;
% 有效能效率
eta_ex = (output.q1-output.q2)/ex;

%% 输出结果
fprintf('Thermal and exergy efficiency for this power cycle are %.3f and %.3f, respectively\n', eta_t, eta_ex)

%% 定义求解方程组
function F = diff_p3_q1(x, InitState, Material, Process, opt)
% 设定容增压比x1和预膨胀系数x2为求解变量
% 目标函数：F1 = p3_known - p3_eval; F2 = q1_known - q1_eval
    Process.lambda = x(1); 
    Process.rho = x(2);
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F(1) = 10.3e6-out.properties.Pressure(3);
    F(2) = 900e3-out.q1;
end