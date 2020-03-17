%% ��ҵ 3-17����5�棩/3-19����4�棩
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-14
%
%% ��ʼ��
clear;
%% �Ծ��ȸ��������й���Ϊ�տ�ϵ
% ��������
cp = 1005; Rg = 8.3145/29e-3;
% �ٶ����ʿ���Ϊ��������
syms p V T m
EOS = p*V == m*Rg*T;
cv = cp-Rg;
% ���ܶ���
U = m*cv*T;
%% ��̬
% A���еĿ���
V_A1 = 0.5; p_A1 = 250e3; T_A1 = 300;
% ����EOS��ù�������
m_A1 = eval(solve(subs(EOS, [p V T], [p_A1 V_A1 T_A1]), m));
% B���еĿ���
V_B1 = 1; p_B1 = 150e3; T_B1 = 1000;
% ����EOS��ù�������
m_B1 = eval(solve(subs(EOS, [p V T], [p_B1 V_B1 T_B1]), m));
% ϵͳ����
U1 = eval(subs(U,[m T], [m_A1 T_A1])+subs(U,[m T], [m_B1 T_B1]));
%% A�Һ�B���ڸ��������о��Ȼ��
Q = 0; W = 0;
% ��dU = Q-W��
dU = 0; 
U2 = U1;
m_A2 = m_A1; m_B2 = m_B1;
%% ��̬
% A�Һ�B�ҵĿ�����Ͼ��ȴﵽ��ͬ��״̬
% ϵͳ����
T2 = eval(solve(U2 == eval(subs(U,m,m_A2)+subs(U,m,m_B2)), T));
V2 = V_A1+V_B1;
m2 = m_A2+m_B2;
p2 = eval(solve(subs(EOS, [m V T], [m2 V2 T2]), p));
%% ϵͳ�ر�
% ϵͳ�ر� = ��A�������ر�+��B�������ر�
% ds(v,T) = cv/T dT + Rg/v dv = cp/T dT - Rg/p dp
% ��A�������ر�
dS_A =  m_A1*(cp*log(T2/T_A1)-Rg*log(p2/p_A1));
% ��B�������ر�
dS_B =  m_B1*(cp*log(T2/T_B1)-Rg*log(p2/p_B1));
dS = dS_A+dS_B;
%% ������
fprintf('T2 = %.1f K, p2 = %.1f kPa, dS = %.1f J/K\n', T2, p2/1e3, dS)