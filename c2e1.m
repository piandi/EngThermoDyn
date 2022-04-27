%% 例题2-1
%
% by Dr. Guan Guoqiang @ SCUT on 2022/2/24

%% 初始化
clear;

%% 初末状态
p1 = 0.2e6; % [Pa]
V1 = 0.9; % [m3]
p2 = p1; V2 = 1.4;

%% 闭口系工质经历可逆定压膨胀
% 计算体积功
syms p V
W1 = int(p1,V,V1,V2);
% 已知工质内能变化
dU = 12e3; % [kJ]
% 由热力学第一定律可得过程热力变化为
Q = dU+W1;
if Q>0 
    heatDirection = '吸热';
else
    heatDirection = '放热';
end
% 克服大气压力做功量
pa = 0.1e6; % 大气压[Pa]
W2 = int(p1-pa,V,V1,V2);
% 工质克服气压做功量转化为活塞动能，其运动速度
mp = 20; % 活塞质量[kg]
c2 = sqrt(W2*2/mp);

%% 输出结果
fprintf('工质从%.1g(m3)可逆等压膨胀到%.1g(m3)%s量为%.3g(kJ)\n',V1,V2,heatDirection,Q/1000)
fprintf('工质膨胀能推动活塞运动速度达到%.3g(m/s)\n',c2)