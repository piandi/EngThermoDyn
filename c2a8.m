%% �κ���ҵ2-8
%
% by �ع�ǿ @ ����������ѧ��2020/03/05
%
clear;
syms x p;
pb = 0.1e6; A = 0.08; k = 400e2;
%% �������еĿ���Ϊ�о��������տ�ϵ
% ����ǰϵͳ״̬��p1 V1 T1
p1 = 0.1013e6; V1 = 0.008; T1=273.15+17;
Rg = 8.3145/29e-3; cv = 0.718e3;
m = p1*V1/T1/Rg;
% ����ǰ��ƽ�⣺���׻������� = (ϵͳ��ѹp1-��ѹpb)*�������A
mg = (p1-pb)*A;
% ���Ⱥ���ƽ�⣺���׻�������+���ɵ�����kx�� = (ϵͳ��ѹp2-��ѹpb)*�������A
p2 = 0.15e6;
fbalance = mg+k*x == (p2-pb)*A;
xval = eval(solve(fbalance,x));
% ���Ⱥ�ϵͳ״̬��p2 V2(x) T2(p2,V2)-��������
V2 = V1+A*xval;
T2 = p2*V2/(m*Rg);
% ����ƽ�⣺������=�տ�ϵ�����仯+����������
dU = m*cv*(T2-T1);
W = eval(int((mg+k*x)+pb*A,x,0,xval));
Q = dU+W;
%% ������
fprintf('ANSWER: Input heat Q = %.2e J\n',Q)