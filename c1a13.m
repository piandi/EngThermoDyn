%% 习题1-13
% 
% by Dr. Guan Guoqiang @ SCUT on 2022/2/27

%% 初始化
clear
syms p v T p1 v1 n v2
assume(n ~= 1)
assume(v2 > v1)

%% 推导理想气体多变过程体积功
% 多变过程定义是
eq1 = p*v^n == p1*v1^n;
% 整理得过程压力表达式
p = solve(eq1,p)
% 计算体积功
w = (p1*v1^n)*int(1/v^n,v)
w = simplify(subs(w,v,v2)-subs(w,v,v1))