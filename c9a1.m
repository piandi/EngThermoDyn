%% �̲ģ���5�棩ϰ��9-1
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
% Attoѭ��
opt = 1;
% ��̬
InitState.p = 100e3;
InitState.T = 35+273.15;
% ����Attoѭ������������
Process.n = Material.kappa; % ����ѹ��������
Process.epsilon = 10;
Process.lambda = 1.2; 
Process.rho = 1;
%
q1 = 650e3;

%% ���̼���
% �������[q1 = 650kJ/kg]�Ķ�����ѹ��
% �趨������ѹ�Ⱥ�Ԥ����ϵ���ĳ�ֵ
x0 = [Process.lambda];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_q1(x, InitState, Material, Process, opt), x0, options);
% ���¹�����������
Process.lambda = x(1);
% ����ѭ����Ч��
output = PowerCycle_ICE(InitState, Material, Process, opt);
eta_t = 1-abs(output.q2)/output.q1;
% ����ͬ���޵Ŀ�ŵЧ��
TH = max(output.properties.Temperature); TC = min(output.properties.Temperature);
eta_c = 1-TC/TH;
% ����MEP
MEP = (output.q1-output.q2)/(output.properties.SpecVol(1)-output.properties.SpecVol(2));

%% ������
fprintf('Properties of power cycle are listed as following\n')
disp(output.properties)
fprintf('Thermal efficiencies of the power cycle and Carnot cycle are %.3f and %.3f, respectively. \n', eta_t, eta_c)
fprintf('MEP = %.3e Pa\n', MEP)

%% ������ⷽ����
function F = diff_q1(x, InitState, Material, Process, opt)
% �趨����ѹ��xΪ������
% Ŀ�꺯����F = q1_known - q1_eval
    Process.lambda = x; 
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F = 650e3-out.q1;
end