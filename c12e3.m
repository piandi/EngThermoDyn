%% 例12-3、12-4
% Rev.0 by GGQ on 2019-6-27
%
clear;
syms t p V Rg T;
%% 按公式(12-28)定义饱和水蒸气压的温度关联式
ps = 2/15*exp(18.5916-3991.11/(t+233.84));
% 干球温度下的水蒸气分压
pv = eval(subs(ps, t, 30))*0.6;
% 露点温度为湿饱和时的温度，即t|_{ps=pv}
tw = eval(subs(finverse(ps, t), t, pv));
% 根据湿度定义
d = 18/29*(pv/(101.3-pv));
% 干空气的分压
pa = 101.3-pv;
% 假设空气满足理想气体
m = p*V/Rg/T;
ma = eval(subs(m, [p V T Rg], [pa 50 (30+273.15) 8.3145/29]));
mv = eval(subs(m, [p V T Rg], [pv 50 (30+273.15) 8.3145/18]));
%% 计算湿焓
ha = 1.005*t;
hv = 2051+1.86*t;
h = ha+d*hv;
H = ma*eval(subs(h, t, 30));
%% 定压冷却到10C时冷凝水量和湿焓值
pv1 = eval(subs(ps, t, 10));
tw1 = eval(subs(finverse(ps, t), t, pv1));
d1 = 18/29*(pv1/(101.3-pv1));
H1 = ma*eval(subs(h, t, 10));
%% 输出结果
fprintf('Dew point is %.2f %cC\n', tw, char(176));
fprintf('Humidity is %.4f kg(steam)/kg(air)\n', d);
fprintf('Mass of dry air and water vapor are %.3f kg and %.3f kg\n', ma, mv)
fprintf('Enthalpy of wet air is %.2f kJ\n', H);
fprintf('(Example 12-4 ref. ans.)\n');
fprintf('Mass of condensate is %.3f kg\n', (d-d1)*ma);
fprintf('Released heat is %.2f kJ\n', H-H1);