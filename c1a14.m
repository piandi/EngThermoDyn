%% 习题1-14
clear;
% 数据点p-V
p = [1.655, 1.069, 0.724, 0.5, 0.396, 0.317, 0.245, 0.193, 0.103]';
V = [114.71, 163.87, 245.81, 327.74, 409.68, 491.61, 573.55, 655.48, 704.64]';
% 在p-V图上绘制数据点
plot(V, p, 'o')
xlabel('V / cm^{3}');
ylabel('p / MPa');
hold on;
% 用梯形公式计算离散点面积分
W_t = trapz(V, p);
% 画出梯形面积
for i = 1:8
    xverts = [V(i); V(i+1); V(i+1); V(i)];
    yverts = [0; 0; p(i+1); p(i)];
    patch(xverts, yverts, 'y');
end
%% Curve Fit
[xData, yData] = prepareCurveData( V, p );
% Set up fittype and options.
ft = fittype( 'smoothingspline' );
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );
% Integrate the fitted curve
int = integrate(fitresult, V, V(1));
% plot the fit curve
plot( fitresult, xData, yData )
hold off;
% Display the fitting error
table(V, p, feval(fitresult, V), p-feval(fitresult, V))
fprintf('Sum of regression error is %.3f.\n', sum(abs(p-feval(fitresult, V))))
W_r = int(end);
fprintf('W_t = %.2f J; W_r = %.2f J\n', W_t, W_r)