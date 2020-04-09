%% 多级压缩总功耗计算函数
%
% 调用参数说明
% pi - (i, double array) 各级压缩后的工质压力向量
% w  - (o, double array) 各级压缩的功耗向量
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function w = MultiStageCompressor(pi)
%% 初始化
% 通过pi分量个数得压缩级数
MStage = length(pi)+1;
%
syms p v T
% 假定工质为理想气体
Rg = 0.287e3; n = 1.3; 
eos = p*v == Rg*T;
% 
w = zeros(MStage,1);

%% 顺次表达状态点性质
% 状态1性质（工质初态）
p1 = 0.1e6; T1 = 20+273.15;
v1 = eval(subs(solve(eos, v), [p T], [p1 T1]));
% 状态2性质（1级压缩后）
p2 = pi(1);
% 工质从状态1通过多变过程（n=1.3）变化到状态2
syms dlnp dlnv
eq1 = dlnp+n*dlnv == 0;
eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
v2 = subs(solve(eq1a, v), p, p2);
T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
% 压缩过程功耗
w1 = -int(solve(eq1a, v), p, p1, p2);
% 级间等压冷却
v2 = subs(solve(eos, v), [p T], [p2 T2]);
% 状态3性质（2级压缩后）
p3 = pi(2);
eq1b = subs(eq1, [dlnp,dlnv], [log(p)-log(p2),log(v)-log(v2)]);
v3 = subs(solve(eq1b, v), p, p3);
T3 = eval(subs(solve(eos, T), [p v], [p3 v3]));
% 压缩过程功耗
w2 = -int(solve(eq1b, v), p, p2, p3);
% 级间等压冷却
v3 = subs(solve(eos, v), [p T], [p3 T2]);
% 状态4性质（3级压缩后，工质终态)
p4 = 12.5e6;
eq1c = subs(eq1, [dlnp,dlnv], [log(p)-log(p3),log(v)-log(v3)]);
v4 = subs(solve(eq1c, v), p, p4);
T4 = eval(subs(solve(eos, T), [p v], [p4 v4]));
% 压缩过程功耗
w3 = -int(solve(eq1c, v), p, p3, p4);
% 级间等压冷却
v4 = subs(solve(eos, v), [p T], [p4 T2]);

%% 输出
w = [w1;w2;w3];
w = eval(w);

end