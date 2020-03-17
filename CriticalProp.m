function [SOUT, Ready] = CriticalProp(SIN, Method)
%% �����ٽ�����
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/9/30
%
%%
% ���������ʼ��
switch nargin
    case 1
        % ���ݹ��������ж��Ƿ�������������������
        Method.Property = SetMethod(SIN);
    case 2
        % �����������
    otherwise
        % ��������쳣����ֹ����
        Setlog('[Abort] Incorrect number of input arguments in CriticalProp()!');
        Ready = 0;
        return
end
% ������ʼ��
SOUT = SIN;
kappa = SOUT.kappa;
Rg = SOUT.Rg;
% �����ٽ�ѹ����
Setlog('Calculate the critical properties.');
if Method.Property == 0 % ��������
    nu = (2/(kappa+1))^(kappa/(kappa-1));
    % ����Ƿ���������ֹ����
    if isfield(SOUT, 'StagnantProp')
        p0 = SOUT.StagnantProp.p;
        T0 = SOUT.StagnantProp.T;
        % �����ٽ�ѹ��
        pc = nu*p0;
        % �����ٽ��¶ȡ������
        Tc = T0*(p0/pc)^((1-kappa)/kappa);
        vc = Rg*Tc/pc;
        % �����ٽ�����
        cfc = sqrt(2*kappa/(kappa+1)*Rg*T0);
        % ����ٽ����
        criticalProp.p = pc;
        criticalProp.T = Tc;
        criticalProp.v = vc;
        criticalProp.cf = cfc;
        SOUT.CriticalProp = criticalProp;
    else
        Setlog('[Abort] Absent stagnant properties!');
        return
    end
end
Ready = 1;