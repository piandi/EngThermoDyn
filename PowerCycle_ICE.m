%% �������ʽ��ȼ����ϼ�������ѭ���ľ���
%
% ���ò���˵��
% InitState - (i struct) ��ʼ״̬������ѧ��������
%          .p (double) ѹ�������ʵ�λ��δ������ͬ��
%          .v (double) �����
%          .T (double) �¶�
% Material  - (i struct) ����
%          .Name (string) ��������
%          .Mw (double) ������
%          .Rg (double) �������峣��
%          .cp (double) ��ѹ����
%          .cv (double) ���ݱ���
% Process   - (i struct) ����������������
%          .n (double) ѹ��������
%          .epsilon (double) ѹ����
%          .lambda (double) ������ѹ��
%          .rho (double) Ԥ����ϵ��
% opt       - (i integer scalar) �����趨
%          = 0 (default) ���͵�ѭ��
%          = 1 ����ѭ��
%          = 2 ������ѭ��
% Output    - (o struct) ������
%          .w  ����
%          .q1 ������
%          .q2 ������
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-14
%
function Output = PowerCycle_ICE(InitState, Material, Process, opt)
% ��������
cp = Material.cp;
cv = Material.cv;
Rg = Material.Rg;
kappa = Material.kappa;
% ������������
n = Process.n;
epsilon = Process.epsilon;
lambda = Process.lambda;
rho = Process.rho;

%% ���μ����״̬
% ״̬1
if isempty(InitState.p) 
    T1 = InitState.T;
    v1 = InitState.v;
    p1 = Rg*T1/v1;
end
if isempty(InitState.v) 
    T1 = InitState.T;
    p1 = InitState.p;
    v1 = Rg*T1/p1;
end
if isempty(InitState.T) 
    p1 = InitState.p;
    v1 = InitState.v;
    T1 = p1*v1/Rg;
end
% ״̬2
v2 = v1/epsilon;
p2 = p1*epsilon^n;
T2 = p2*v2/Rg;
% ״̬3
v3 = v2;
p3 = lambda*p2;
T3 = p3*v3/Rg;
% ״̬4
p4 = p3;
v4 = rho*v3;
T4 = p4*v4/Rg;
% ״̬5
v5 = v1;
p5 = p4*(v4/v5)^n;
T5 = p5*v5/Rg;

%% ������̼���
% ������
Output.q1 = cv*(T3-T2)+cp*(T4-T3);
Output.q2 = cv*(T5-T1);
Output.w  = Output.q1-Output.q2;

%% ���
switch opt
    case(0)
        State = [1:5]';
        Pressure = [p1 p2 p3 p4 p5]';
        SpecVol = [v1 v2 v3 v4 v5]';
        Temperature = [T1 T2 T3 T4 T5]';
    case(1)
        State = [1:4]';
        Pressure = [p1 p2 p4 p5]';
        SpecVol = [v1 v2 v4 v5]';
        Temperature = [T1 T2 T4 T5]';        
    case(2)
        State = [1:4]';
        Pressure = [p1 p3 p4 p5]';
        SpecVol = [v1 v3 v4 v5]';
        Temperature = [T1 T3 T4 T5]'; 
end

Output.properties = table(State, Pressure, SpecVol, Temperature);

end