%% 确定滞止性质
% r0: original
% r1: use customized function CritProps_hs0.m
% r2: add dependancy check
% r3: add precheck function ChkFiles.m
clear;
% 检查需要调用的第三方文件是否存在
chk_filename = {'XSteam'};
result_chk = ChkFiles(chk_filename);
if all(result_chk)
    fprintf('All needed files existed\n');
else
    fprintf('STOP due to one of needed files NOT existed\n');
    return
end
% 喷管进口处单位质量流动蒸汽的动能
cf1 = 100; 
ke1 = cf1^2/2/1000;
% 喷管进口处蒸汽比焓和熵
p1 = 20; T1 = 300;
h1 = XSteam('h_pT', p1, T1);
s1 = XSteam('s_pT', p1, T1);
% 滞止状态的比焓和熵
h0 = h1+ke1;
s0 = s1; % 假定流动为可逆绝热过程
% 滞止压力和温度
p0 = XSteam('p_hs', h0, s0);
T0 = XSteam('T_hs', h0, s0);
%% 确定喉部性质（临界性质）
[pc, vc, Tc, wc] = CritProps_hs0(h0, s0);
%% 确定质量流率
A = 20.e-4;
mrc = A*wc/vc;
%% 喷管出口状态
p2 = 1;
s2 = s0; % 假定流动为可逆绝热过程
h2 = XSteam('h_ps', p2, s2);
ke2 = (h0-h2)*1000;
cf2 = sqrt(2*ke2);
v2 = XSteam('v_ps', p2, s2);
A2 = mrc*v2/cf2;
%% 输出结果
fprintf('Velocity at nozzle (ie, local sound speed) is %.1f m/s\n', wc);
fprintf('Effluent velocity is %.1f m/s\n', cf2);
fprintf('Mass flowrate and outlet area of the Laval nozzel are %.1f kg/s and %.1f cm2, respectively\n', mrc, A2*1.e4);