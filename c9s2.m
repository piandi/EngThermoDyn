%% �̲ģ���5�棩��������������
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
% ����ѭ��
opt = 1;
% ��̬
InitState.p = 101.325e3;
InitState.T = 40+273.15;
% �������͵�ѭ������������
Process.n = 1; % ����ѹ��������
Process.epsilon = 2; 
Process.lambda = 1.2; % ��ֵ
Process.rho = 1;
%
T3 = 400+273.15;

%% ���̼���
% ��������
v1 = Material.Rg*InitState.T/InitState.p;
m = 3e-6/v1*2;
% �������[T3 = 673.15K]�Ķ�����ѹ��
% �趨������ѹ�ȵĳ�ֵ
x0 = [Process.lambda];
options = optimset('Display', 'iter');
[x,fval,exitflag] = fsolve(@(x)diff_T3(x, InitState, Material, Process, opt), x0, options);
% ���¹�����������
Process.lambda = x; 
% ����ѭ����Ч��
output = PowerCycle_ICE(InitState, Material, Process, opt);
% �������������Ч��
v1 = output.properties.SpecVol(1);
v2 = output.properties.SpecVol(2);
v3 = output.properties.SpecVol(3);
v4 = output.properties.SpecVol(4);
w12 = Material.Rg*InitState.T*log(v2/v1);
w34 = Material.Rg*T3*log(v4/v3);
eta_t = abs(w12)/w34;

%% ������
fprintf('Properties of power cycle:\n')
disp(output.properties)
fprintf('Work output is %.4e J with thermal efficiency of %.3f\n', (w34+w12)*m, eta_t)

%% ������ⷽ����
function F = diff_T3(x, InitState, Material, Process, opt)
% �趨����ѹ��x1��Ԥ����ϵ��x2Ϊ������
% Ŀ�꺯����F1 = p3_known - p3_eval; F2 = q1_known - q1_eval
    Process.lambda = x;
    out = PowerCycle_ICE(InitState, Material, Process, opt);
    F = 673.15-out.properties.Temperature(3);
end