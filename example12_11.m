%% ��12-11
% Rev.0 by GGQ on 2019-6-28
%
clear;
syms t p V Rg T d;
%% ����ʽ(12-28)���履��ˮ����ѹ���¶ȹ���ʽ
ps = 2/15*exp(18.5916-3991.11/(t+233.84));
% �����¶��µ�ˮ������ѹ
pv1 = eval(subs(ps, t, 15))*0.65;
pv2 = eval(subs(ps, t, 32))*1.00;
% ����ʪ�ȶ���
d1 = 18/29*(pv1/(100-pv1));
d2 = 18/29*(pv2/(100-pv2));
% �ɿ����ķ�ѹ
pa1 = 100-pv1;
pa2 = 100-pv2;
% �ɿ��������� [kg/s]
ma = pa1*1100/60*(pa1/100)/(273.15+15)/(8.3145/29);
% ����ˮ�� [kg/s]
qwm = ma*(d2-d1);
%% ����ʪ��
ha = 1.005*t;
hv = 2051+1.86*t;
h = ha+d*hv;
H1 = ma*eval(subs(h, [t d], [15 d1]));
H2 = ma*eval(subs(h, [t d], [32 d2]));
% ����ˮ��
qw = (H2-H1)/(4.18*(38-17));