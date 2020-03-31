%% 学生问题：c4s1
% A容器（3m3、80kPa、27C）抽真空并向B容器从真空充气压缩使B中空气温度和压力分别为27C和640kPa所需的最小功
%
% by Dr. Guan Guoqiang @ SCUT on 2020-03-31
%
%% 初始化
clear
T = 27+273.15;
syms p V m;
Rg = 0.285e3; % 全部量都为国际单位
% A容器初态
pA1 = 80e3; VA = 3; TA1 = T;
% B容器终态
pB2 = 640e3; TB2 = 27+273.15;
% 假定工质空气为理想气体
EOS = p*V == m*Rg*T;
% 初始A中的工质质量
mA1 = eval(subs(solve(EOS, m), [p V], [pA1 VA]));
% 计算B容器的体积
mB2 = mA1;
VB = eval(subs(solve(EOS, V), [p m], [pB2 mB2]));
vB2 = VB/mB2;
%% =================以下过程并非最小功========================
% %% 对全部工质建立闭口系，系统状态从(pA1,vA1)变化到(pB2,vB2)
% % 假定工质经历可逆等温变化，其体积功为
% W = m*Rg*TA1*(VB-VA);
% %
%% A容器向真空等温自由膨胀到平衡，pA2 = pB1, TB1 = TA2
% 由膨胀后工质所占总体积计算平衡压力
% A容器
TA2 = TA1;
pA2 = eval(subs(solve(EOS, p), [V m], [VA+VB mA1]));
vA2 = (VA+VB)/mA1;
mA2 = VA/vA2;
% B容器
TB1 = TA2;
pB1 = pA2;
vB1 = vA2;
mB1 = VB/vB1;
%% 以平衡后A容器中的工质为闭口系，从状态(pA2,vA2)经历等温变化为(pB2,vB2)
% 工质初态时所占体积
VA1 = VA;
% 工质终态时所占体积
TB2 = TB1;
VA2 = eval(subs(solve(EOS, V), [p m], [pB2 mA2]));
% 工质做功量为
WA = eval(int(subs(solve(EOS, p), m, mA2), V, VA1, VA2));
%% 以平衡后B容器中的工质为闭口系，从状态(pB1,vB1)经历等温变化为(pB2,vB2)
% 工质初态时所占体积
VB1 = VB;
% 工质终态时所占体积
VB2 = mB1*vB2;
% 工质做功量为
WB = eval(int(subs(solve(EOS, p), m, mB1), V, VB1, VB2));
%
%% 将A容器抽至真空后重新打开A和B容器间的联通阀，工质从B容器向A容器自由等温膨胀到平衡
% A容器中的工质状态为TA2、pA2、vA2和mA2
% B容器中的工质状态为TB1、pB1、vB1和mB1
% 此过程熵变
dS = mA1*Rg*log(vA2/vB2);
% 环境温度
T0 = 27+273.15;
% 工质做功能力变化
Ex = -T0*dS;
%% 输出
fprintf('Input work is %.1e W\n', -(WA+WB))
if Ex < 0
    prompt = 'where the negative value indicates the decrease of working ability';
else
    prompt = 'where the positive value indicates the increase of working ability';
end
fprintf('Change of work ability is %.1e W, %s\n', Ex, prompt)