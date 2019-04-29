%% 习题2-3
syms p v X Length c
p0 = 0.1e6; p1 = 0.5e6; mp = 10; m = 1; T = 300.15;
% 假设工质为氧气且满足理想气体模型
Rg = 8.315/32*1e3;
v1 = Rg*T/p1;
% 闭口系中工质压力反比于体积
p = @(v)(p1*v1/v);
% 闭口系工质膨胀做功
W = m*int(p(v)-p0, v, v1, 2*v1);
% 假设功完全转化为活塞的动能
eq = 0.5*mp*c^2 == W;
cmax = eval(solve(eq, c>0, c));
% 输出结果
fprintf('Ans.: Max. Velocity = %.1f m/s\n', cmax);