%% ������1��2020��ҵ���ؿ�����������ѧ���Ծ�
%
% Dr. Guan Guoqiang @ SCUT on 2020/6/11
%

%% ˳�μ���ѹ����������ѭ���ĸ�״̬
% ����1-2Ϊ����ѹ��������2-3Ϊ��ѹ���ȣ�����3-4Ϊ��������,����4-1Ϊ��ѹ����
T1 = 290; % ��λ[K]
syms p v T
eq3 = p*v == Rg*T;
syms p1 p2 T2
v1 = subs(solve(eq3, v),[p T],[p1 T1]);
v2 = subs(solve(eq3, v),[p T],[p2 T2]);
eq4 = p1*v1^kappa == p2*v2^kappa;
eq5 = p2/p1 == 5;
solve([eq4 eq5],T2)
