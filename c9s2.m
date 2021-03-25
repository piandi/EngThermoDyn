%% 教材（第5版）补充例：热气机
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
% 动力循环
opt = 1;
% 初态
InitState.p = 101.325e3;
InitState.T = 40+273.15;
% 定义萨巴德循环的特征参数
Process.n = 1; % 等温压缩和膨胀
Process.epsilon = 2; 
Process.lambda = 1.2; % 初值
Process.rho = 1;
%
T3 = 400+273.15;

%% 过程计算
% 工质质量
v1 = Material.Rg*InitState.T/InitState.p;
m = 3e-6/v1*2;
% 求解满足[T3 = 673.15K]的定容增压比
% 设定定容增压比的初值
x0 = [Process.lambda];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_T3(x, InitState, Material, Process, opt), x0, options);
% 更新过程特征参数
Process.lambda = x; 
% 计算循环热效率
output = PowerCycle_ICE(InitState, Material, Process, opt);
% 计算输出功及热效率
v1 = output.properties.SpecVol(1);
v2 = output.properties.SpecVol(2);
v3 = output.properties.SpecVol(3);
v4 = output.properties.SpecVol(4);
w12 = Material.Rg*InitState.T*log(v2/v1);
w34 = Material.Rg*T3*log(v4/v3);
eta_t = abs(w12)/w34;

%% 输出结果
fprintf('Properties of power cycle:\n')
disp(output.properties)
fprintf('Work output is %.4e J with thermal efficiency of %.3f\n', (w34+w12)*m, eta_t)

%% 定义求解方程组
function F = diff_T3(x, InitState, Material, Process, opt)
% 设定容增压比x1和预膨胀系数x2为求解变量
% 目标函数：F1 = p3_known - p3_eval; F2 = q1_known - q1_eval
    Process.lambda = x;
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F = 673.15-out.properties.Temperature(3);
end