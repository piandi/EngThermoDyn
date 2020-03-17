%% ��ҵ3-13
%
% Dr. GUAN, Guoqiang @ SCUT on 2020-03-13
%
clear;
%% ���������幤�����Ϊ�տ�ϵ
% �������ʣ���̲ĸ���2��
Rg = 208.1; % ��ֵ��ΪSI����ͬ��
cv = 0.312e3;
% �ٶ��������Ϊ��������
syms p V T m
EOS = p*V == m*Rg*T;
%% ��̬
p1 = 0.6e6; T1 = 600; m1 = 5; 
% ������������״̬���̵õ����
V1 = eval(solve(subs(EOS, [p T m], [p1 T1 m1]), V));
%% ����
% ��֪�������ܱ仯Ϊ�㣬���������������ܱ仯��ϵͳ���¶ȱ仯������
T2 = T1;
%% ��̬
V2 = 3*V1; m2 = m1;
% ������������״̬���̵õ�ѹ��
p2 = eval(solve(subs(EOS, [V T m], [V2 T2 m2]), p));
%% �����ر�
% ds(v,T) = cv/T dT + Rg/v dv
dS = m1*(cv*log(T2/T1)+Rg*log(V2/V1));
%% ���
fprintf('T2 = %.1f K, p2 = %.3f MPa, dS = %.1f J/K\n', T2, p2/1e6, dS)