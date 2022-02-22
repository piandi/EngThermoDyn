%% 计算题3-1
% 有一台换热器用冷却水将15kg/s的热水由200°C降温到120°C；已知冷却水流量为25kg/s、温度为30°C，假定该换热器为理想换热器且环境温度为25°C，求该过程的熵增和㶲损。

%% 初始化
clear
m1 = 15; % 热侧流率（kg/s）
m2 = 25; % 冷侧流率（kg/s）
T11 = 200+273.15; % 热侧入口温度（K）
T12 = 120+273.15; % 热侧出口温度（K）
T21 = 30+273.15; % 冷侧入口温度（K）
p1 = 2500; % 热侧操作压力（kPa）
p2 = p1; % 冷侧操作压力（kPa）
T0 = 25+273.15; % 环境温度（K）

%% 传热量
% 方法1：按水定值比热为4.18kJ/kg-K计算
cp = 4.18; % [kJ/kg-K]
Q1 = m1*cp*(T12-T11);
T22 = -Q1/m2/cp+T21;
fprintf('（1a）假定水比热固定为4.18kJ/kg-K可得传热量为%.2fkW，冷却水出水温度为%.2fK\n',abs(Q1),T22)
% 方法2：严格按XSteam计算水性质
h11 = XSteam('h_pT',p1/100,T11-273.15);
h12 = XSteam('h_pT',p1/100,T12-273.15);
Q1 = m1*(h12-h11);
h21 = XSteam('h_pT',p2/100,T21-273.15);
h22 = @(x)XSteam('h_pT',p2/100,x-273.15);
dQ = @(x)abs(m2*(h22(x)-h21)+Q1);
[T22,dQval] = fminbnd(dQ,T21+10,373.15);
fprintf('（1b）严格按XSteam计算水性质可得传热量为%.2fkW，冷却水出水温度为%.2fK\n',abs(Q1),T22)

%% 换热过程熵增
% 热侧熵变化
s11 = XSteam('s_pT',p1/100,T11-273.15);
s12 = XSteam('s_pT',p1/100,T12-273.15);
dS1 = m1*(s12-s11);
% 冷侧熵变化
s21 = XSteam('s_pT',p2/100,T21-273.15);
s22 = XSteam('s_pT',p2/100,T22-273.15);
dS2 = m2*(s22-s21);
% 换热过程熵变化
dS = dS1+dS2;
fprintf('（2）换热过程熵增为%.4gkJ/K\n',dS)

%% 换热过程㶲损
Sg = dS;
I = T0*Sg;
fprintf('（3）换热过程㶲损为%.4gkJ\n',I)