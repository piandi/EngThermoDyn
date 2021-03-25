%% 密闭气缸抽气过程模拟
% 说明：
% 用抽气机对容积为10L的刚性气瓶进行等温抽气。每次抽气量为0.1L且抽出气体性状等于残留
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-10
%
clear;
% 建立系统：对抽气前的瓶内气体建立闭口系
% 表达性质：假定气体为理想气体，则m = pV/Rg/T
% 描述过程：对气瓶中残留气体质量 + 抽出气体质量 = 抽气前气瓶中气体质量
%          m(i+1) + me(i+1) = m(i)
%          抽气前后钢瓶体积、抽气体积、气体温度和气体常数不变
%          p(i)V = p(i+1)(V+Ve)
%
% 初始条件
V = 10; Ve = 0.1;
p(1) = 1;
i = 1;
% 抽气
while p(i) > 0.5
    p(i+1) = p(i)*V/(V+Ve); % 每次抽气后的气瓶压力
    i = i+1;
end
% 输出
fprintf('Number of required suction: %d\n',i-1)
plot(p,'bo')
xlabel('Number of required suction');
ylabel('Pressure/Initial Pressure');