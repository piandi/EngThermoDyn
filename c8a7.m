%% 第287页：习题(8-7)
%
% by Dr. Guan Guoqiang @ SCUT on 2022/4/11

%% 初始化
clear
% 工质特性：理想气体空气
air = MaterialPG;
air.cp = 1.004; air.cv = 0.717;
n = 1.3;

%% 压气机
% 初态
p1 = 100; T1 = 20+273.15;
s1 = StatePG;
s1.Material = air;
s1.p = p1; s1.T = T1;
% 各级增压比相同即有
p4 = 12500;
pi = (p4/p1)^(1/3);
% 第一级压缩后
p2 = p1*pi;
s2 = StatePG;
s2.p = p2;
% 计算一级压缩后状态2
[~,wc1,~,dh1] = Polytropic(n,s1,s2);
% 第二级压缩
p3 = p2*pi;
s3 = StatePG;
s3.p = p3;
% 级间冷却
s2a = StatePG; 
s2a.Material = air;
s2a.p = s2.p;
s2a.T = T1;
% 计算二级压缩后状态2
[~,wc2,~,dh2] = Polytropic(n,s2a,s3);
% 第三级压缩
s4 = StatePG;
s4.p = p4;
% 级间冷却
s3a = StatePG; 
s3a.Material = air;
s3a.p = s2.p;
s3a.T = T1;
% 计算三级压缩后状态3
[~,wc3,~,dh3] = Polytropic(n,s3a,s4);
% 单级压缩时
s4b = StatePG;
s4b.p = p4;
% 计算单级压缩后状态2
[~,wc,~,dh] = Polytropic(n,s1,s4b);
% 没有级间冷却的情况
% 第一级压缩后
p2 = p1*pi;
s2c = StatePG;
s2c.p = p2;
% 计算一级压缩后状态2
[~,wc1c,~,dh1c] = Polytropic(n,s1,s2c);
% 第二级压缩
p3 = p2*pi;
s3c = StatePG;
s3c.p = p3;
% 计算二级压缩后状态2
[~,wc2c,~,dh2c] = Polytropic(n,s2c,s3c);
% 第三级压缩
s4c = StatePG;
s4c.p = p4;
% 计算三级压缩后状态3
[~,wc3c,~,dh3c] = Polytropic(n,s3c,s4c);

%% 输出
fprintf('（1）压气机理论功耗为%.4g kJ/kg\n',abs(wc1+wc2+wc3))
fprintf('（2）各级压缩后的出口温度分别为%.4g K、%.4g K和%.4g K\n',s2.T,s3.T,s4.T)
fprintf('（3）无级间冷却时的功耗为%.4g kJ/kg；各级出口温度分别为%.4g K、%.4g K和%.4g K\n',abs(wc1c+wc2c+wc3c),s2c.T,s3c.T,s4c.T)
fprintf('（4）单级压缩时功耗为%.4g kJ/kg；出口温度为%.4g K\n',abs(wc),s4b.T)

