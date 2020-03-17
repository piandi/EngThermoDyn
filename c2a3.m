%% ϰ��2-3
syms p v X Length c
p0 = 0.1e6; p1 = 0.5e6; mp = 10; m = 1; T = 300.15;
% ���蹤��Ϊ������������������ģ��
Rg = 8.315/32*1e3;
v1 = Rg*T/p1;
% �տ�ϵ�й���ѹ�����������
p = @(v)(p1*v1/v);
% �տ�ϵ������������
W = m*int(p(v)-p0, v, v1, 2*v1);
% ���蹦��ȫת��Ϊ�����Ķ���
eq = 0.5*mp*c^2 == W;
cmax = eval(solve(eq, c>0, c));
% ������
fprintf('Ans.: Max. Velocity = %.1f m/s\n', cmax);