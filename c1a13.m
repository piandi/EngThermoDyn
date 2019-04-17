%% 习题1-14
clear;
% 输入已知条件
p = [1.655, 1.069, 0.724, 0.5, 0.396, 0.317, 0.245, 0.193, 0.103]';
V = [114.71, 163.87, 245.81, 327.74, 409.68, 491.61, 573.55, 655.48, 704.64]';
% 画出p-V图
plot(V, p, 'o')
xlabel('V / cm^{3}');
ylabel('p / MPa');
% 用梯形公式直接数值积分得做功量
W_t = trapz(V, p);
for i = 1:8
    xverts = [V(i); V(i+1); V(i+1); V(i)];
    yverts = [0; 0; p(i+1); p(i)];
    patch(xverts, yverts, 'y');
end
% 用三次多项式拟合p(V)曲线
pp = polyfit(V, p, 3);
% 检查拟合效果
table(V, p, polyval(pp, V), p-polyval(pp, V))
fprintf('Sum of regression error is %.3f.\n', sum(abs(p-polyval(pp, V))))
% 画出拟合曲线
x = linspace(min(V), max(V));
y = polyval(pp, x);
hold on;
plot(x, y)
hold off;
% 用拟合结果计算做功量
W_r = trapz(x, y);
fprintf('W_t = %.2f (J); W_r = %.2f (J)\n', W_t, W_r)