%% 多级压缩总功耗计算函数
%
% 调用参数说明
% pi       - (i, double array) 各级压缩后的工质压力向量
% material - (i, struct array(2)) 初、终态工质性质
% process  - (i, struct array(NStage)) 各级压缩过程特性
% wval     - (o, double array) 各级压缩的功耗向量
%
% by Dr. Guan Guoqiang @ SCUT on 2020-04-09
%
function [wval,pval,vval,Tval] = MultiStageCompressor(pi, materials, processes)
%% 初始化
% 通过pi分量个数得压缩级数
MStage = length(pi)+1;
NState = length(pi)+2;
%
% syms p v T
% 假定工质为理想气体
Rg = materials(1).Rg; 
% eos = p*v == Rg*T;
% 
wval = zeros(MStage,1);
pval = zeros(NState,1);
vval = zeros(NState,1);
Tval = zeros(NState,1);
% 代入已知条件
% 初态
pval(1) = materials(1).p; Tval(1) = materials(1).T; % 采用国际单位（下同）
% 中间态
pval(2:NState-1) = pi;
% 终态
pval(NState) = materials(2).p;

%% 顺次表达状态点性质   
% 状态1性质（工质初态）
% vval(1) = eval(subs(solve(eos, v), [p T], [pval(1) Tval(1)]));
vval(1) = Rg*Tval(1)/pval(1);
for i = 1:MStage
    % 压缩前状态
    p1 = pval(i); v1 = vval(i); T1 = Tval(i);
    % 压缩后状态
    p2 = pval(i+1);
    % 工质从状态1通过多变过程（n=1.3）变化到状态2
    n = processes(i).n;
%     syms dlnp dlnv
%     eq1 = dlnp+n*dlnv == 0;
%     eq1a = subs(eq1, [dlnp,dlnv], [log(p)-log(p1),log(v)-log(v1)]);
%     v2 = subs(solve(eq1a, v), p, p2);
    v2 = v1*exp((log(p1) - log(p2))/n);
%     T2 = eval(subs(solve(eos, T), [p v], [p2 v2]));
    T2 = p2*v2/Rg;
    Tval(i+1) = T2;
    % 压缩过程功耗
%     wval(i) = -eval(int(solve(eq1a, v), p, p1, p2));
    w = @(p)((p1./p).^(1/n)*v1);
    wval(i) = integral(w, p1, p2);    
    % 级间等压冷却
%     v2 = subs(solve(eos, v), [p T], [p2 T2]);
    v2 = Rg*Tval(1)/p2;
    vval(i+1) = v2;    
end

end