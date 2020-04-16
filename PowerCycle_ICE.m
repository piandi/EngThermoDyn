%% 计算活塞式内燃机混合加热理想循环的净功
%
% 调用参数说明
% InitState - (i struct) 初始状态的热力学基本性质
%          .p (double) 压力（国际单位，未声明下同）
%          .v (double) 比体积
%          .T (double) 温度
% Material  - (i struct) 物性
%          .Name (string) 物质名称
%          .Mw (double) 分子量
%          .Rg (double) 质量气体常数
%          .cp (double) 定压比热
%          .cv (double) 定容比热
% Process   - (i struct) 过程特征参数定义
%          .n (double) 压缩、膨胀
%          .epsilon (double) 压缩比
%          .lambda (double) 定容增压比
%          .rho (double) 预膨胀系数
% opt       - (i integer scalar) 操作设定
%          = 0 (default) 萨巴德循环
%          = 1 奥托循环
%          = 2 狄塞尔循环
% Output    - (o struct) 输出结果
%          .w  净功
%          .q1 吸热量
%          .q2 放热量
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-14
%
function Output = PowerCycle_ICE(InitState, Material, Process, opt)
% 工质性质
cp = Material.cp;
cv = Material.cv;
Rg = Material.Rg;
kappa = Material.kappa;
% 过程特征参数
n = Process.n;
epsilon = Process.epsilon;
lambda = Process.lambda;
rho = Process.rho;

%% 依次计算各状态
% 状态1
if isempty(InitState.p) 
    T1 = InitState.T;
    v1 = InitState.v;
    p1 = Rg*T1/v1;
end
if isempty(InitState.v) 
    T1 = InitState.T;
    p1 = InitState.p;
    v1 = Rg*T1/p1;
end
if isempty(InitState.T) 
    p1 = InitState.p;
    v1 = InitState.v;
    T1 = p1*v1/Rg;
end
% 状态2
v2 = v1/epsilon;
p2 = p1*epsilon^n;
T2 = p2*v2/Rg;
% 状态3
v3 = v2;
p3 = lambda*p2;
T3 = p3*v3/Rg;
% 状态4
p4 = p3;
v4 = rho*v3;
T4 = p4*v4/Rg;
% 状态5
v5 = v1;
p5 = p4*(v4/v5)^n;
T5 = p5*v5/Rg;

%% 代入过程计算
% 吸热量
Output.q1 = cv*(T3-T2)+cp*(T4-T3);
Output.q2 = cv*(T5-T1);
Output.w  = Output.q1-Output.q2;

%% 输出
switch opt
    case(0)
        State = [1:5]';
        Pressure = [p1 p2 p3 p4 p5]';
        SpecVol = [v1 v2 v3 v4 v5]';
        Temperature = [T1 T2 T3 T4 T5]';
    case(1)
        State = [1:4]';
        Pressure = [p1 p2 p4 p5]';
        SpecVol = [v1 v2 v4 v5]';
        Temperature = [T1 T2 T4 T5]';        
    case(2)
        State = [1:4]';
        Pressure = [p1 p3 p4 p5]';
        SpecVol = [v1 v3 v4 v5]';
        Temperature = [T1 T3 T4 T5]'; 
end

Output.properties = table(State, Pressure, SpecVol, Temperature);

end