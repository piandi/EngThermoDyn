%% ������ܵ���ֹ����
% r0: original
% r1: compare the cases with and without the throttle
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
% ����ǰ
p1 = 40; T1 = 450; 
h1 = XSteam('h_pT', p1, T1);
s1 = XSteam('s_ph', p1, h1);
% �������ʵ���ֵ���ڽ���ǰ
cf1 = 100;
p1a = 30;
h1a = h1;
s1a = XSteam('s_ph', p1a, h1a);
% ��ֹ�ʡ���
ke1 = cf1^2/2/1000; 
h0a = h1a+ke1;
h0 = h1+ke1;
s0a = s1a;
s0 = s1;
%% ȷ���ٽ����ʣ���ܺ�����p��v��T�����٣�
% ������
[pca, vca, Tca, wca] = CritProps_hs0(h0a, s0a);
sca = s0a;
hca = XSteam('h_ps', pca, sca);
% ������
[pc, vc, Tc, wc] = CritProps_hs0(h0, s0);
sc = s0;
hc = XSteam('h_ps', pc, sc);
%% ��ܺ������
massflow = 0.5;
% ������
Aca = massflow*vca/wca;
% ������
Ac = massflow*vc/wc;
%% ��ܳ��ڹ�������
% ������
p2a = 10;
s2a = s0a;
h2a = XSteam('h_ps', p2a, s2a);
cf2a = sqrt(2*(hca-h2a)*1000+wca^2);
v2a = XSteam('v_ps', p2a, s2a);
A2a = massflow*v2a/cf2a;
% ������
p2 = 10;
s2 = s0;
h2 = XSteam('h_ps', p2, s2);
cf2 = sqrt(2*(hc-h2)*1000+wc^2);
v2 = XSteam('v_ps', p2, s2);
A2 = massflow*v2/cf2;
%% �������̼�������ʧ��
p2 = p2a;
s2 = s1;
h2 = XSteam('h_ps', p2, s2);
dWt = massflow*((h1-h2)-(h1a-h2a));
%% ����������������ʧ
loss = massflow*298.15*(s1a-s1);
%% ������
fprintf('Solution of Example 7-4:\n');
fprintf('Cross-section areas of nozzle and outlet are %.2f cm2 and %.2f cm2, respectively\n', Aca*1.e4, A2a*1.e4);
fprintf('Technical work loss is %.1f kW\n', dWt);
fprintf('Working ability loss is %.1f kW\n', loss);
fprintf('Outlet velocity of the nozzle w and w/o throttle are %.1f m/s and %.1f m/s, respectively\n', cf2a, cf2);