%% ��ҵ����5�棩7-18
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-07
%
%% ��ʼ��
clear
syms p T v s ds_p ds_T dv_T dp dT cp mu_J Rg
%% �Ƶ�����ϵ������ʽ(7-32)
% �ر�
ds = ds_p*dp+ds_T*dT;
% Ӧ�����˹Τ��ϵʽ
ds = subs(ds, ds_p, -dv_T);
% Ӧ�ñ��ȶ���
ds = subs(ds, ds_T, cp/T);
% �ܺ�����ϵʽ
dh = T*ds+v*dp;
% ���������ʱ�Ϊ��
eq1 = dh == 0;
% ����ϵ������
eq2 = mu_J == dT/dp;
% ����eq1��2
eq3 = solve(eq1, dT) == solve(eq2, dT);
mu_J = solve(eq3, mu_J);
%% Ӧ����������״̬���̣�PG-EOS��
eos = p*v == Rg*T;
% ��v��dv_T����mu_J�ɵ�
output = subs(mu_J, [v dv_T], [solve(eos, v) diff(solve(eos, v), T)]);
%% ���
fprintf('For perfect gas, the Joule�CThomson coefficient is %f.\n', output)