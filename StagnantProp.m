function [SOUT, Ready] = StagnantProp(SIN, Method)
%% ������ֹ����
%
% �������
% SIN - (struct scalar) .Name ������
%                       .Mass ���� [kg]
%                       .Velocity �ٶ� [m/s]
%                       .Pressure ѹ�� [Pa]
%                       .Temperature �¶� [K]
%                       .SpecVolume ����� [m3/kg]
%                       .kappa ����ָ��
%                       .SpecEnthalpy ���� [J/kg]
%                       .cp ��ѹ���� [J/kg-K]
%                       .cv ���ݱ��� [J/kg-K]
%                       .Rg �������峣�� [J/kg-K]
%                       .Mw ������ [mol/kg]
% Method - (struct scalar) ���㷽��
%
% �������
% SOUT   - (struct scalar) same struct as SIN
% Ready  - (integer scalar) Complete successfully
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/9/30
%

%% ��ʼ��
SOUT = SIN; 
Ready = 0;
% ���������ʼ��
switch nargin
    case 1
        % ���ݹ��������ж��Ƿ�������������������
        Method.Property = SetMethod(SIN);
    case 2
        
    otherwise
        Setlog('[Abort] Incorrect number of input arguments in StagnantProp()!');
        Ready = 0;
        return
end
%% ������ֹ����
Setlog('Calculate the stagnant properties.');
switch Method.Property
    case 0 % �������������
        % ���ͨ�����峣���Ƿ����
        if ~isfield(SOUT, 'Rg') && isfield(SOUT, 'Mw') % ͨ��ͨ�����峣��R����Rg
            SOUT.Rg = 8.3145/SOUT.Mw;
            Setlog('Calculate Rg from generalized gas constant.');          
        end
        % ��ɾ���ָ������ѹ���ȡ����ݱ��Ⱥ��������峣���ļ���
        [SOUT, Ready] = CalcKCCR(SIN);
        if Ready
            SOUT.Mw = 8.3145/SOUT.Rg; % ��Mw�����ڣ�ͨ��R��Rg����Mw
            Setlog('Calculate Mw from Rg.');
        else
            Setlog('[Abort] Required parameters are absent!');
            return
        end
        % ������ֹ�¶ȡ�ѹ��
        if isfield(SOUT, 'Velocity')
            Ready = 1;
        else
            Ready = 1;
            SOUT.Velocity = 0;
            Setlog('[Warning] Velocity is unknown and default 0 is used!');  
        end
        if isfield(SOUT, 'Temperature')
            Ready = 1;
        else
            Ready = 1;
            SOUT.Temperature = 273.15+25;
            Setlog('[Warning] Temperature is unknown and default 298.15K is used!'); 
        end
        if SOUT.cp ~= 0 && Ready
            kappa = SOUT.kappa;
            Rg = SOUT.Rg;
            cf = SOUT.Velocity;
            cp = SOUT.cp;
            T = SOUT.Temperature;
            T0 = cf^2/2/cp+T;
            p = SOUT.Pressure;
            p0 = p*(T/T0)^(kappa/(1-kappa));
            v0 = Rg*T0/p0;
            % �����ֹ����
            stagProp.T = T0;
            stagProp.p = p0;
            stagProp.v = v0;
            SOUT.StagnantProp = stagProp;
        else
            setlog('[Abort] Stagnant temperature calculation stopped due to cp = 0��'); 
            return
        end
    case 1 % ��ˮ�����������
        Setlog('Use XSteam() to calculate the stagnant properties'); 
    otherwise
        Setlog('[Warning] Skip the properties calculation'); 
end
Ready = 1;
