function [ pc, vc, Tc, wc ] = CritProps_hs0( h0, s0 )
%% Determine the critical properties of steam at high-speed flows
% Input stagnant properties h-s
% h0 - stagnant specific enthalpy [kJ/kg]
% s0 - stagnant specific entropy [kJ/kg-K]
% Output p-v-T properties at which the Mach number is 1
% pc - critical pressure [bar]
% vc - critical specific volume [m3/kg]
% Tc - critical temperature [C]
% wc - sound speed [m/s]
%
% Addons Depandancy
% This function requires the XSteam 
%
% by Guoqiang GUAN Dr. @ SCUT, 2019-6-11

%% ȷ�������ʣ��ٽ����ʣ�
% Get the stagnant pressure [bar]
p0 = XSteam('p_hs', h0, s0);
% �趨��ѹ����ֵ
pc = 0.5*p0;
sc = s0; % �ٶ�����Ϊ������ȹ���
eps = 1; 
% ���������ѹ��ʹ֮������㾫��
while eps > 0.01 % ��������Ϊ���ƫ��1%
    wc = XSteam('w_ps', pc, sc);
    kec = wc^2/2/1000;
    hc = h0-kec;
    pc_new = XSteam('p_hs', hc, sc);
    eps = abs((pc_new-pc)/pc_new);
    pc = pc_new;
end
% ����������¶�
vc = XSteam('v_ps', pc, sc);
Tc = XSteam('T_ps', pc, sc);
%
end

