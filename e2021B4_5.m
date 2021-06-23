%% 闭口系中理想气体（cp=1.005 kJ kg-1 K-1、cv=0.785kJ kg-1 K-1）从初态（1.5MPa、650K）经历多变过程（n=1.04）变化到终态（0.2MPa）的热量变化量为____kJ kg-1（注意保留4位有效数值）
%
% by Dr. Guan Guoqiang @ SCUT on 2021/6/7

clear
syms v

% 工质性质
cp = 1.005; cv = 0.785;
Rg = cp-cv;
% 初态
p1 = 1.5e3; T1 = 650;
v1 = Rg*T1/p1;
% 多变过程
n = 1.04;
p2 = 0.2e3;
v2 = (p1/p2)^(1/n)*v1;
T2 = p2*v2/Rg;
w = eval(int((v1/v)^n*p1,v,v1,v2));
du = cv*(T2-T1);
q = du+w;
fprintf('热量变化量为%.4g kJ/kg\n',q)