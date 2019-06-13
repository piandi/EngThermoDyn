%% 计算喷管的滞止性质
% r0: original
% r1: compare the cases with and without the throttle
% r2: add dependancy check
clear;
% 检查需要调用的第三方文件是否存在
chk_filename = 'XSteam';
fprintf('The following files have been checked for existence ...\n');
fprintf('%s\n', chk_filename);
if exist(chk_filename, 'file') == 2
    fprintf('Okey');
else
    fprintf('File not exist and stop running\n')
    return;
end
% 节流前
p1 = 40; T1 = 450; 
h1 = XSteam('h_pT', p1, T1);
s1 = XSteam('s_ph', p1, h1);
% 节流后工质的焓值等于节流前
cf1 = 100;
p1a = 30;
h1a = h1;
s1a = XSteam('s_ph', p1a, h1a);
% 滞止焓、熵
ke1 = cf1^2/2/1000; 
h0a = h1a+ke1;
h0 = h1+ke1;
s0a = s1a;
s0 = s1;
%% 确定临界性质（喷管喉部流体p、v、T和声速）
% 节流后
[pca, vca, Tca, wca] = CritProps_hs0(h0a, s0a);
sca = s0a;
hca = XSteam('h_ps', pca, sca);
% 不节流
[pc, vc, Tc, wc] = CritProps_hs0(h0, s0);
sc = s0;
hc = XSteam('h_ps', pc, sc);
%% 喷管喉部截面积
massflow = 0.5;
% 节流后
Aca = massflow*vca/wca;
% 不节流
Ac = massflow*vc/wc;
%% 喷管出口工质性质
% 节流后
p2a = 10;
s2a = s0a;
h2a = XSteam('h_ps', p2a, s2a);
cf2a = sqrt(2*(hca-h2a)*1000+wca^2);
v2a = XSteam('v_ps', p2a, s2a);
A2a = massflow*v2a/cf2a;
% 不节流
p2 = 10;
s2 = s0;
h2 = XSteam('h_ps', p2, s2);
cf2 = sqrt(2*(hc-h2)*1000+wc^2);
v2 = XSteam('v_ps', p2, s2);
A2 = massflow*v2/cf2;
%% 节流过程技术功损失量
p2 = p2a;
s2 = s1;
h2 = XSteam('h_ps', p2, s2);
dWt = massflow*((h1-h2)-(h1a-h2a));
%% 节流后做功能力损失
loss = massflow*298.15*(s1a-s1);
%% 输出结果
fprintf('Solution of Example 7-4:\n');
fprintf('Cross-section areas of nozzle and outlet are %.2f cm2 and %.2f cm2, respectively\n', Aca*1.e4, A2a*1.e4);
fprintf('Technical work loss is %.1f kW\n', dWt);
fprintf('Working ability loss is %.1f kW\n', loss);
fprintf('Outlet velocity of the nozzle w and w/o throttle are %.1f m/s and %.1f m/s, respectively\n', cf2a, cf2);