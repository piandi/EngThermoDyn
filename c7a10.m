%% 作业7-10
%
% by Dr. Guan Guoqiang @ SCUT on 2022-4-6

%% 初始化
clear
% 工质为理想气体空气
Rg = 287; cp = 1004; % [J/kg-K]
cv = cp-Rg;
kappa = cp/cv;
% EOS
v = @(p,T)(Rg*T/p);
% 绝热过程出口压力计算式
pout = @(pin,Tin,Tout)(pin*(Tout/Tin)^(kappa/(kappa-1)));

% 喷管进口条件
p1 = 0.58e6; T1 = 440; A1 = 2.6e-3; Qm = 1.5; % 单位SI
v1 = v(p1,T1);
Qv1 = Qm*v1;
cf1 = Qv1/A1;
% 滞止性质
T0 = T1+0.5*cf1^2/cp;
p0 = pout(p1,T1,T0);
% 临界性质
Tcr = T0/((1+kappa)/2);
pcr = pout(p0,T0,Tcr);
vcr = v(pcr,Tcr);
c = sqrt(kappa*Rg*Tcr);
% 假定缩放管喉部状态为临界状态，喷管出口压力应小于临界压力
Ac = Qm*vcr/c;
p2 = 0.14e6;
if p2 < pcr
    v2 = vcr*(pcr/p2)^(1/kappa); % 出口比体积
    T2 = p2*v2/Rg;
    cf2 = sqrt(2*cp*(Tcr-T2)+c^2);
    A2 = Qm*v2/cf2;
else
    error('喷管出口压力小于临界压力！');
end

%% 输出
fprintf('喷管喉部及出口截面积分别为%.3g m2和%.3g m2；出口气速为%.3g m/s\n',Ac,A2,cf2)
