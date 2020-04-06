%% 作业（第5版）7-18
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-07
%
%% 初始化
clear
syms p T v s ds_p ds_T dv_T dp dT cp mu_J Rg
%% 推导焦汤系数计算式(7-32)
% 熵变
ds = ds_p*dp+ds_T*dT;
% 应用麦克斯韦关系式
ds = subs(ds, ds_p, -dv_T);
% 应用比热定义
ds = subs(ds, ds_T, cp/T);
% 能函数关系式
dh = T*ds+v*dp;
% 节流过程焓变为零
eq1 = dh == 0;
% 焦汤系数定义
eq2 = mu_J == dT/dp;
% 联立eq1和2
eq3 = solve(eq1, dT) == solve(eq2, dT);
mu_J = solve(eq3, mu_J);
%% 应用理想气体状态方程（PG-EOS）
eos = p*v == Rg*T;
% 将v和dv_T代入mu_J可得
output = subs(mu_J, [v dv_T], [solve(eos, v) diff(solve(eos, v), T)]);
%% 输出
fprintf('For perfect gas, the Joule–Thomson coefficient is %f.\n', output)