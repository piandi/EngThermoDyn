%% ��ҵ7-4
% ��ʼ��
global logs
logs = struct([]); % ��־��������¼�������
% ������ܽ��ڴ��Ĺ���״̬
S1.Name = 'Air_PG'; S1.cp = 1005; S1.kappa = 1.4;
S1.Pressure = 2e6; S1.Temperature = 273.15+27; 
S1.Velocity = 0.0;
% �趨�������ʼ���ģ��
Method.Property = SetMethod(S1);
% ������ֹ����
S0 = StagnantProp(S1, Method);
% �����ٽ�����
S0 = CriticalProp(S0, Method);
pc = S0.CriticalProp.p;
Tc = S0.CriticalProp.T;
vc = S0.CriticalProp.v;
cfc = S0.CriticalProp.cf;
p0 = S0.StagnantProp.p;
T0 = S0.StagnantProp.T;
kappa = S0.kappa;
Rg = S0.Rg;
% ȷ������ѹ��
pb = 1.5e6; % ��ѹ
if pb < pc
    cf2 = cfc;
    p2 = pc;
else
    p2 = pb;
end
% ��������¶�
S2 = S0;
S2.Pressure = p2;
S2.Temperature = T0*(p0/p2)^((1-kappa)/kappa);
% ������ڱ����
S2.SpecVolume = Rg*T2/p2;
% �����������
A2 = 10e-4;
S2.Velocity = cfc;
S2.Mass = 1/S2.SpecVolume*S2.Velocity*A2;
% �����־
Setlog('', 2);