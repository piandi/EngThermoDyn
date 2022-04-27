%% “气体动力循环”课堂测验2：参考答案
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/23

%% 10 某燃气轮机采用简单的定压加热理想循环。循环最高温度为900K，最低的温度和压力分别为300K和120kPa。工质性质近似为空气（cp=1.004kJ/kg，kappa=1.4），求压气机增压比为12时的装置净输出功（kJ/kg）
% 初始化
clear
syms p v T
% 工质性质
cp = 1.004; kappa = 1.4;
cv = cp/kappa; Rg = cp-cv;
% 状态1
p1 = 120; T1 = 300;
v1 = Rg*T1/p1;
% 可逆绝热压缩到状态2
p2 = 12*p1; 
v2 = v1*(p1/p2)^(1/kappa);
T2 = p2*v2/Rg;
% 定压升温至状态3
T3 = 900; p3 = p2;
v3 = Rg*T3/p3;
% 可逆绝热膨胀到状态4
p4 = p1;
T4 = T3*(p4/p3)^(1-1/kappa);
v4 = Rg*T4/p4;
% 压缩机功耗
wc = -cp*(T2-T1);
% 透平输出功
wt = -cp*(T4-T3);
% 循环净功
wnet = wc+wt;
% 输出结果
fprintf('净输出功量为%.4gkJ/kg\n',wnet)

