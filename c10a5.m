%% 第5版P352习题10-5
% 工质R134a由CoolProps计算
%
% by Dr. Guan Guoqiang @ SCUT on 2022-4-19

%% 初始化
clear

%%
Qm = 1000; % [kg/s]
% 生蒸汽温度为20C，假设朗肯循环过热度5C
T1 = 273.15+20;
T6 = T1-5;
p6 = Props('P','T',T6,'Q',1,'R134a');
p1 = p6;
h1 = Props('H','P',p1,'T',T1,'R134a');
s1 = Props('S','P',p1,'T',T1,'R134a');
% 绝热膨胀（放热温度为10C）
T2 = 273.15+10;
s2 = s1;
h2 = Props('H','S',s2,'T',T2,'R134a');
% 完全冷凝2-3
T3 = T2;
h3 = Props('H','T',T3,'Q',0,'R134a');
s3 = Props('S','T',T3,'Q',0,'R134a');
% 绝热增压3-4
s4 = s3;
p4 = p6;
h4 = Props('H','S',s4,'P',p4,'R134a');
% 循环的功率
wt = h1-h2;
wc = h3-h4;
wnet = wt+wc;
P = Qm*wnet;
% 循环吸热量
q1 = h1-h4;
% 热效率
eta = wnet/q1;

%% 输出
fprintf('过热温度为5K时，循环功率和热效率分别为%.4g kW和%.3g %%\n',P,eta*100)