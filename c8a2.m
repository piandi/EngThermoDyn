%% 第5版作业8-2
%
% by Dr. Guan Guoqiang @ SCUT on 2022-04-15

%% 初始化
clear
% 工质特性：理想气体空气
air = MaterialPG;
air.cp = 1.004; air.cv = 0.717;

%% 各过程状态
% 初态
s1 = StatePG;
s1.Material = air;
s1.p = 100; s1.T = 273.15+50;
m = 0.032/s1.v;
% 终态
s2 = StatePG;
s2.p = 320; 

%% 计算过程特性
fun = @(x)FunGetN(x,s1,s2,0.012/m);
x0 = s1.Material.kappa;
n = fzero(fun,x0);
[w,wt,du,dh] = Polytropic(n,s1,s2);
q = dh+wt;

%% 输出
fprintf('压缩过程多变指数为%.3f；压缩后空气温度%.4g K；压气机功耗为%.4g kW；压缩过程散热量为%.4g kW\n', ...
      n,s2.T,abs(wt*m),abs(q)*m)

% 求多变指数
function dv = FunGetN(n,s1,s2,v)
    s = StatePG;
    s.p = s2.p;
    Polytropic(n,s1,s);
    dv = s.v-v;
end