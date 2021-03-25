%% c9s1 比较在混合加热理想循环中采用相同的特性参数改用等温压缩和膨胀的功率变化
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-13
%

%% 初始化
clear
syms p v T % 工质状态
assume(p>0 & v>0 & T>0)
syms cp cv Rg kappa n % 工质性质
assume(cv>0 & cp>cv & Rg>0 & n>=0 & kappa>1)
eos = p*v == Rg*T;
eq1 = cp-cv == Rg;
eq2 = cp/cv == kappa;
% cp = cv+Rg;
syms dlnp dlnv dlnT
eq3 = dlnp+n*dlnv == 0;
eq4 = dlnp+dlnv == dlnT;

%% 依次计算各状态
% 状态1
syms T1 v1
assume(T1>0 & v1>0)
p1 = subs(solve(eos, p), [T v], [T1 v1]);
% 状态2
syms v2 epsilon
assume(epsilon>1)
v2 = solve(epsilon == v1/v2, v2);
sol1 = solve([eq3 eq4], [dlnp dlnv]);
eq5 = dlnv == sol1.dlnv;
eq5a = subs(eq5, [dlnv dlnT], [log(v)-log(v1),log(T)-log(T1)]);
T2 = simplify(subs(solve(eq5a, T), v, v2));
p2 = subs(solve(eos, p), [T v], [T2 v2]);
% 状态3
syms p3 lambda
assume(lambda>1)
v3 = v2;
p3 = solve(lambda == p3/p2, p3);
T3 = subs(solve(eos, T), [p v], [p3 v3]);
% 状态4
syms v4 rho
assume(rho>1)
p4 = p3;
v4 = solve(rho == v4/v3, v4);
T4 = subs(solve(eos, T), [p v], [p4 v4]);
% 状态5
syms p5
v5 = v1;
eq5b = subs(eq5, [dlnv dlnT], [log(v)-log(v4),log(T)-log(T4)]);
T5 = simplify(subs(solve(eq5b, T), v, v5));
p5 = subs(solve(eos, p), [T v], [T5 v5]);

%% 计算热效率
q1 = cv*(T3-T2)+cp*(T4-T3);
q2 = cv*(T1-T5);
sol2 = solve([eq1 eq2], [cp cv]);
eta_t = simplify(subs(1-q2/q1, [cp cv], [sol2.cp sol2.cv]));

%% 膨胀、压缩过程采用绝热与等温的区别
nfactor = factor(eta_t, n);
nfactor(2)
diff_sT = subs(nfactor(2), n, kappa)-subs(nfactor(2), n, 1) % eta_t(s)-eta_t(T) = nfactor(1)*diff_sT