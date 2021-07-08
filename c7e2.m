%% ȷ����ֹ����
% r0: original
% r1: use customized function CritProps_hs0.m
% r2: add dependancy check
% r3: add precheck function ChkFiles.m
clear;
% �����Ҫ���õĵ������ļ��Ƿ����
chk_filename = {'XSteam'};
result_chk = ChkFiles(chk_filename);
if all(result_chk)
    fprintf('All needed files existed\n');
else
    fprintf('STOP due to one of needed files NOT existed\n');
    return
end
% ��ܽ��ڴ���λ�������������Ķ���
cf1 = 100; 
ke1 = cf1^2/2/1000; % ��λ��kJ/kg
% ��ܽ��ڴ��������ʺ���
p1 = 20; T1 = 300;
h1 = XSteam('h_pT', p1, T1);
s1 = XSteam('s_pT', p1, T1);
% ��ֹ״̬�ı��ʺ���
h0 = h1+ke1;
s0 = s1; % �ٶ�����Ϊ������ȹ���
% ��ֹѹ�����¶�
p0 = XSteam('p_hs', h0, s0);
T0 = XSteam('T_hs', h0, s0);
%% ȷ�������ʣ��ٽ����ʣ�
[pc, vc, Tc, wc] = CritProps_hs0(h0, s0);
%% ȷ����������
A = 20.e-4;
mrc = A*wc/vc;
%% ��ܳ���״̬
p2 = 1;
s2 = s0; % �ٶ�����Ϊ������ȹ���
h2 = XSteam('h_ps', p2, s2);
ke2 = (h0-h2)*1000;
cf2 = sqrt(2*ke2);
v2 = XSteam('v_ps', p2, s2);
A2 = mrc*v2/cf2;
%% ������
fprintf('Velocity at nozzle (ie, local sound speed) is %.1f m/s\n', wc);
fprintf('Effluent velocity is %.1f m/s\n', cf2);
fprintf('Mass flowrate and outlet area of the Laval nozzel are %.1f kg/s and %.1f cm2, respectively\n', mrc, A2*1.e4);