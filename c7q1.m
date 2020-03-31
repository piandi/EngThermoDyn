%% 课堂测验：c7q1
% 闭口系中理想气体（cp=1.005 kJ/kg-K、cv=0.785kJ/kg-K）从初态（1.5MPa、650K）经历多变过程（n=1.04）变化到终态（0.25MPa）的热量变化量
%
% by Dr. Guan Guoqiang @ SCUT on 2020-03-30
%
%%
% 初始化
clear;
syms p v T
cp = 1.05e3; cv = 0.785e3; % 比热单位为J/kg-K
n = 1.04; % 多变指数
% 工质为理想气体，由迈耶公式可得气体常数
Rg = cp-cv;
EOS = p*v == Rg*T;
% 初态
p1 = 1.5e6; % 单位：Pa
T1 = 350+273.15; % 单位：K
v1 = eval(subs(solve(EOS, v), [p T], [p1 T1])); % 单位：m3/kg
% 终态
p2 = 0.25e6; % 单位：Pa
% 闭口系经历多变过程
v2 = (p1*v1^n/p2)^(1/n); % 单位：m3/kg
T2 = eval(subs(solve(EOS, T), [p v], [p2 v2])); % 单位：K
% 系统内能变化为
du = cv*(T2-T1);
% 系统对外做功（体积功）量为
w = eval(int(p1*(v1/v)^n*v,v,v1,v2)); % 单位：J/kg
% 系统吸热量为
q = du+w;
%% 输出
% 由q的正负判定吸放热
if q < 0
    prompt = 'Released';
else
    prompt = 'Absorbed';
end
prompt = [prompt,' heat is %.1f J/kg\n'];
% 命令行显示
fprintf(prompt, q);