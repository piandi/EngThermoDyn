%% 例4-7

%% 初始化
clear
% 工质性质
cv = 0.717; kappa = 1.4;
cp = cv*kappa; % [kJ/kg-K]
Rg = cp-cv;

%% 闭口系B
% 初态
pB1 = 0.45e6; TB1 = 900; mB = 1;
VB1 = mB*Rg*TB1/pB1*1e3; % [m3]
% 终态
pB2 = 0.30e6;
% 绝热过程
VB2 = ((pB1*VB1^kappa)/pB2)^(1/kappa); % [m3]
TB2 = pB2*VB2/mB/Rg/1e3;
% 能量平衡方程（dU = Q-W）可知WB = -dUB
dUB = mB*cv*(TB2-TB1);
WB = -dUB;

%% 闭口系A
% 初态
pA1 = 0.45e6; TA1 = 900; mA = 1;
VA1 = mA*Rg*TA1/pA1*1e3; % [m3]
% 终态
pA2 = 0.30e6;
% B体积增加量 = A体积减少量
VA2 = VA1-(VB2-VB1);
TA2 = pA2*VA2/mA/Rg/1e3;
% 能量平衡方程（dU = Q-W）
dUA = mA*cv*(TA2-TA1);
WA = -WB;
QA = dUA+WA;

%% 输出
fprintf('A和B的体积分别为%.4gm3和%.4gm3\n',VA2,VB2)
fprintf('系统A的热量变化为%.4gkJ\n',QA)