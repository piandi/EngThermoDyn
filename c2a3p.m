%% 习题2-3（扩展版）
clear;
syms p X(t) x(t);
syms Length Area;
assume([t, X(t)], 'positive');
p0 = 0.1e6; p1 = 0.5e6; mp = 10; m = 1; T = 300.15;
Rg = 8.315/32*1e3;
% 假设工质为氧气且满足理想气体模型
Area = m*Rg*T/p1/Length;
% 闭口系中工质压力反比于体积 = A*(l+x)
p = @(X)(p1*Length/(Length+X));
ode0 = mp*diff(X, t, 2) == (p(X)-p0)*Area;
% 将活塞运动距离无因次化
ode1 = subs(ode0, X, x*Length);
% 假设L=1
ode2 = subs(ode1, Length, 1);
% 将化简的活塞位置写入自定义odefun1，进而数值求解
[t, xdx] = ode45(@odefun1, [0, 0.05], [0, 0]);
% 画出不同时刻活塞的位置及速度大小
[ax,p1,p2] = plotyy(t, xdx(:, 1), t, xdx(:, 2));
ylabel(ax(1),'Displacement (m)') % label left y-axis
ylabel(ax(2),'Velocity Magnitude (m/s)') % label right y-axis
xlabel(ax(1),'Time (s)') % label x-axis