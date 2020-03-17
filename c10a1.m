%% �κ���ҵ��10-1
% (s10.1) ʪ�������п�ŵѭ�����������¶ȷֱ�Ϊ200 C��50 C����̬Ϊ200 C����ˮ�������������ͺ���50 C���ȣ���̬Ϊ200
% C����ˮ��(1)��ˮ����s-Tͼ�ϻ����������߲�����ÿ�ŵѭ����״̬�㣻��2��ˮ��������������ĸɶȣ���3�������ʸ�Ϊ������ѭ��������ı仯��
%
% revision 0 by GGQ on 2019-6-20
%% begin
clear;
% check file dependancy
prerun;
%% draw the saturation curve on s-T plot
T_sat = 20:2:350;
s_sat = zeros(size(T_sat));
sL_sat = s_sat;
sV_sat = s_sat;
for i = 1:size(T_sat,2)
    sL_sat(i) = XSteam('sL_T', T_sat(i));
    sV_sat(i) = XSteam('sV_T', T_sat(i));
end
hold on;
xlabel('$s$ (kJ kg$^{-1}$ C$^{-1}$)', 'Interpreter', 'latex');
ylabel('$T$ ($^{\circ}$C)', 'Interpreter', 'latex');
p = plot(sL_sat, T_sat, sV_sat, T_sat);
for i = 1:size(p, 1)
    p(i).Color = 'blue';
    p(i).LineStyle = '--';
end
%% draw the Carrot cycle
% initialize
T = zeros(1, 4);
p = T;
s = T;
h = T;
% properties at point 4
T(4) = 200;
s(4) = XSteam('sL_T', T(4));
p(4) = XSteam('psat_T', T(4));
v(4) = XSteam('vL_T', T(4));
% properties at point 1
T(1) = 200; 
s(1) = XSteam('sV_T', T(1));
p(1) = XSteam('psat_T', T(1));
v(1) = XSteam('vV_T', T(1));
% properties at point 2
T(2) = 50; 
s(2) = s(1);
p(2) = XSteam('psat_T', T(2));
v(2) = XSteam('v_ps', p(2), s(2));
x = XSteam('x_ps', p(2), s(2));
% properties at point 3
T(3) = T(2);
s(3) = s(4);
p(3) = XSteam('psat_T', T(3));
v(3) = XSteam('v_ps', p(3), s(3));
% plot point 1-2-3-4
plot([s, s(1)], [T, T(1)], 'r-o');
hold off;
% output work = net absorption heat [kJ/kg]
q_s = (s(1)-s(4))*(T(1)-T(2));
%% in case of air with assuming as perfect gas
Rg = 0.287; cp = 1.004; cv = 0.717; kappa = 1.4;
% point 1 and 3 have the same p and T as previous case
pa = p; Ta = T;
% properties of point 2
pa(2) = pa(1)*(Ta(2)/Ta(1))^(kappa/(1+kappa));
% entropy change for process 2-3
ds = -Rg*(log(pa(3))-log(pa(2)));
q_a = ds*(Ta(4)-T(3));
%% output results
fprintf('Vapor fraction of expanded steam is %.3f\n', x);
fprintf('Decrease %.1f %% of output for changing the working medium from steam to air \n', (q_s-q_a)/q_s*100);