%% 课测c2q10：刚性容器初始有1kg压力和温度分别为0.5MPa和298.2K的空气，发现容器缓慢地漏气，当容器漏剩0.5kg时的放热量为____kJ？（空气的比焓和比内能分别满足h/(J/kg) = 1005 T/K和u/(J/kg) = 718 T/K）
%
% by Dr. Guan Guoqiang @ SCUT on 2022/2/25

%% 初始化
clear
h = @(T)(1005*T);
u = @(T)(718*T);
Rg = 1005-718; % [J/kg-K]

%% 2个闭口系
% 闭口系A：容器剩余部分工质从初态膨胀到终态
% 闭口系B：B排出大气部分工质从初态膨胀到大气状态
% 大气状态
pb = 0.1e6; Tb = 298.2; vb = Rg*Tb/pb;
% 初态
mA = 0.5; % [kg]
pA1 = 0.5e6; % [MPa]
TA1 = 298.2; % [K]
mB = 0.5; pB1 = pA1; TB1 = TA1;
% 终态
TA2 = TA1; pA2 = 0.5*pA1;
TB2 = TB1; pB2 = pb; 
% 过程
% 闭口系A和B的内能变化均为0
% 故气体的等温膨胀功 = 吸热量
syms V
% 对于闭口系A
VA1 = mA*Rg*TA1/pA1; % 初态体积
VA2 = mA*Rg*TA2/pA2; % 终态体积
WA = int(mA*Rg*TA1/V,V,VA1,VA2); % 等温膨胀体积功 [J]
QA = eval(WA); % 系统吸热量 [J]
% 对于闭口系B
VB1 = mB*Rg*TB1/pB1;
VB2 = mB*Rg*TB2/pB2;
WB = int(mB*Rg*TB1/V,V,VB1,VB2); % 等温膨胀体积功 [J]
QB = eval(WB); % 系统吸热量 [J]
% 输出
fprintf('吸热量为%.3gkJ\n',(QA+QB)/1000)

%% 开口系工质流到环境
% 假定工质从初态流到环境时比体积不变
% 初态
p1 = 0.5e6; T1 = 298.2; v1 = Rg*T1/p1;
m1 = 1.0; V = m1*v1;
m2 = 0.5;
% 流动功
syms m
Wf = eval(Rg*T1*(m2-m1)-pb*V*int(1/m,m,1,0.5));
% 流出工质等压膨胀
We = (m1-m2)*pb*(vb-v1);
% 残留工质从初态膨胀到终态
% 输出
fprintf('流动功%.3gkJ\n',Wf/1000)
