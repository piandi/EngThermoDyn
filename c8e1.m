%% �̲ģ���5�棩��8-1
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-08
%
%% ��ʼ��
clear;
syms p v T
% �ٶ�����Ϊ��������
Rg = 0.287e3; n = 1.35; 
eos = p*v == Rg*T;

%% ˳�α��״̬������
% ״̬1���ʣ�δֵ֪�÷��ű�����ʾ��
p1 = 0.098e6; T1 = 17+273.15;
v1 = eval(subs(solve(eos, v), [p T], [p1 T1]));
syms m1
V1 = m1*v1;
%
% ״̬2���ʣ�δֵ֪�÷��ű�����ʾ��
syms p2 v2 T2 
% ͨ��1-2���̼���
% 1-2Ϊ�����̵�����״̬�仯����
syms dlnp dlnv dlnT
eq1 = dlnp + n*dlnv == 0; % �����̵�΢����ʽ
eq1a = subs(eq1, [dlnp,dlnv], [log(p2)-log(p1),log(v2)-log(v1)]);
% Ӧ��eos��״̬2
eq1b = subs(eos, [p v T], [p2 v2 T2]);
%
% ״̬3���ʣ�δֵ֪�÷��ű�����ʾ��
p3 = 0.35e6;
syms m3
% ͨ��2-3���̼���
% 2-3Ϊ��״̬�������̵�����״̬�仯����
eq2 = p2 == p3;
%
% �������
sol1 = solve([eq1a eq1b eq2], [p2 v2 T2]);
p2 = eval(sol1.p2);
v2 = eval(sol1.v2);
T2 = eval(sol1.T2);
%
v3 = v2;
V3 = m3*v3;

%% ��������
% ��֪���ݱ�sigma
sigma = 0.05;
eq3 = sigma == V3/(V1-V3);
% ��֪������������
m = 0.5;
eq4 = m1-m3 == m;
% �������
sol2 = solve([eq3,eq4], [m1,m3]);
m1 = eval(sol2.m1);
m3 = eval(sol2.m3);

%% ���
fprintf('Air in cylinder is %.4f kg\n', m1)
