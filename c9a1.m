%% 教材（第5版）习题9-1
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
% Atto循环
opt = 1;
% 初态
InitState.p = 90e3;
InitState.T = 10+273.15;
% 定义Atto循环的特征参数
Process.n = Material.kappa; % 绝热压缩和膨胀
Process.epsilon = 9;
Process.lambda = 1.2; 
Process.rho = 1;
%
q1 = 2400e3;

%% 过程计算
% 求解满足[q1 = 650kJ/kg]的定容增压比
% 设定定容增压比和预膨胀系数的初值
x0 = [Process.lambda];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_q1(x, InitState, Material, Process, opt), x0, options);
% 更新过程特征参数
Process.lambda = x(1);
% 计算循环热效率
output = PowerCycle_ICE(InitState, Material, Process, opt);
eta_t = 1-abs(output.q2)/output.q1;
% 计算同温限的卡诺效率
TH = max(output.properties.Temperature); TC = min(output.properties.Temperature);
eta_c = 1-TC/TH;
% 计算MEP
MEP = (output.q1-output.q2)/(output.properties.SpecVol(1)-output.properties.SpecVol(2));

%% 输出结果
fprintf('Properties of power cycle are listed as following\n')
disp(output.properties)
fprintf('Thermal efficiencies of the power cycle and Carnot cycle are %.3f and %.3f, respectively. \n', eta_t, eta_c)
fprintf('MEP = %.3e Pa\n', MEP)

%% 定义求解方程组
function F = diff_q1(x, InitState, Material, Process, opt)
% 设定容增压比x为求解变量
% 目标函数：F = q1_known - q1_eval
    Process.lambda = x; 
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F = 650e3-out.q1;
end