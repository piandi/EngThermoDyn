%% ϰ��2-3����չ�棩
clear;
syms p X(t) x(t);
syms Length Area;
assume([t, X(t)], 'positive');
p0 = 0.1e6; p1 = 0.5e6; mp = 10; m = 1; T = 300.15;
Rg = 8.315/32*1e3;
% ���蹤��Ϊ������������������ģ��
Area = m*Rg*T/p1/Length;
% �տ�ϵ�й���ѹ����������� = A*(l+x)
p = @(X)(p1*Length/(Length+X));
ode0 = mp*diff(X, t, 2) == (p(X)-p0)*Area;
% �������˶���������λ�
ode1 = subs(ode0, X, x*Length);
% ����L=1
ode2 = subs(ode1, Length, 1);
% ������Ļ���λ��д���Զ���odefun1��������ֵ���
[t, xdx] = ode45(@odefun1, [0, 0.05], [0, 0]);
% ������ͬʱ�̻�����λ�ü��ٶȴ�С
[ax,p1,p2] = plotyy(t, xdx(:, 1), t, xdx(:, 2));
ylabel(ax(1),'Displacement (m)') % label left y-axis
ylabel(ax(2),'Velocity Magnitude (m/s)') % label right y-axis
xlabel(ax(1),'Time (s)') % label x-axis