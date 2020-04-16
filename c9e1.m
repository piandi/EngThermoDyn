%% �̲ģ���5�棩��9-1
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-15
%

%% ��ʼ��
clear

%% �������ݽṹ
% InitState - (i struct) ��ʼ״̬������ѧ��������
%          .p (double) ѹ�������ʵ�λ��δ������ͬ��
%          .v (double) �����
%          .T (double) �¶�
InitState = struct('p', [], 'v', [], 'T', []);
% Material  - (i struct) ������������
%          .Name (string) ��������
%          .MW (double) ������
%          .Rg (double) �������峣��
%          .cp (double) ��ѹ����
%          .cv (double) ���ݱ���
%          .kappa (double) ����ָ��
Material = struct('Name', "Air", 'MW', 28.97, 'Rg', 287, 'cp', 1.004e3, 'cv', 0.717e3, 'kappa', 1.4);
% Process   - (i struct) ����������������
%          .n (double) ѹ��������
%          .epsilon (double) ѹ����
%          .lambda (double) ������ѹ��
%          .rho (double) Ԥ����ϵ��
Process = struct('n', [], 'epsilon', [], 'lambda', [], 'rho', []);

%% ��֪����
% ���͵�ѭ��
opt = 0;
% ��̬
InitState.p = 0.17e6;
InitState.T = 60+273.15;
% �������͵�ѭ������������
Process.n = Material.kappa; % ����ѹ��������
Process.epsilon = 14.5;
Process.lambda = 1.2; 
Process.rho = 1.2;
%
p3 = 10.3e6;
q1 = 900e3;
T0 = 20+273.15; % �����¶�

%% ���̼���
% �������[p3 = 10.3MPa; q1 = 900kJ/kg]�Ķ�����ѹ�Ⱥ�Ԥ����ϵ��
% �趨������ѹ�Ⱥ�Ԥ����ϵ���ĳ�ֵ
x0 = [Process.lambda Process.rho];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_p3_q1(x, InitState, Material, Process, opt), x0, options);
% ���¹�����������
Process.lambda = x(1); 
Process.rho = x(2);
% ����ѭ����Ч��
output = PowerCycle_ICE(InitState, Material, Process, opt);
eta_t = 1-abs(output.q2)/output.q1;
% �������ȹ����ر�
cp = Material.cp; Rg = Material.Rg;
p2 = output.properties.Pressure(2); p4 = output.properties.Pressure(4);
T2 = output.properties.Temperature(2); T4 = output.properties.Temperature(4);
s24 = cp*log(T4/T2)-Rg*log(p4/p2);
% ƽ�������¶�
Tm = q1/s24;
% �����е���Ч����
ex = (1-T0/Tm)*q1;
% ��Ч��Ч��
eta_ex = (output.q1-output.q2)/ex;

%% ������
fprintf('Thermal and exergy efficiency for this power cycle are %.3f and %.3f, respectively\n', eta_t, eta_ex)

%% ������ⷽ����
function F = diff_p3_q1(x, InitState, Material, Process, opt)
% �趨����ѹ��x1��Ԥ����ϵ��x2Ϊ������
% Ŀ�꺯����F1 = p3_known - p3_eval; F2 = q1_known - q1_eval
    Process.lambda = x(1); 
    Process.rho = x(2);
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F(1) = 10.3e6-out.properties.Pressure(3);
    F(2) = 900e3-out.q1;
end