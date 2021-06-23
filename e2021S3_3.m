%% 计算题：3-3
% 某电厂采用一次抽气回热的蒸汽动力循环，假定循环各过程均为理想可逆，新蒸汽的温度和压力分别为350°C和4.0MPa，乏汽压力为4kPa，抽气状态为饱和蒸汽。求（1）抽气压力，（2）抽气量为0.12时的循环热效率，（3）耗气率

%% 初始化
clear

% 生蒸汽状态
p1 = 40; % [bar]
T1 = 350; % [C]
h1 = XSteam('h_pT',p1,T1);
s1 = XSteam('s_pT',p1,T1);
% 绝热膨胀为乏汽
s2 = s1;
p2 = 4/100;
h2 = XSteam('h_ps',p2,s2);
% 绝热膨胀至饱和蒸汽后从汽轮机抽出
ds = @(x)abs(XSteam('sV_p',x)-s1);
pa = fminbnd(ds,p2,p1);
ha = XSteam('hV_p',pa);
alpha = 0.12; % 抽气比

% 乏汽全凝为饱和水
h3 = XSteam('hL_p',p2);
% 回热器
h4 = (1-alpha)*h3+alpha*ha;

% 吸热量
q = h1-h4;
% 做功量
w = (h1-ha)+(1-alpha)*(ha-h2);
% 热效率
eta_T = w/q;

%% 输出
fprintf('（1）抽气压力为%.1fbar\n',pa)
fprintf('（2）循环热效率为%.4g\n',eta_T)
fprintf('（3）耗气率为%.4gkg/kJ\n',1/w)