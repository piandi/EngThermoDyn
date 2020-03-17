function [SOUT, Ready] = CriticalProp(SIN, Method)
%% 计算临界性质
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/9/30
%
%%
% 输入参数初始化
switch nargin
    case 1
        % 根据工质名称判定是否按理想气体计算相关性质
        Method.Property = SetMethod(SIN);
    case 2
        % 输入参数正常
    otherwise
        % 输入参数异常，终止程序
        Setlog('[Abort] Incorrect number of input arguments in CriticalProp()!');
        Ready = 0;
        return
end
% 变量初始化
SOUT = SIN;
kappa = SOUT.kappa;
Rg = SOUT.Rg;
% 计算临界压力比
Setlog('Calculate the critical properties.');
if Method.Property == 0 % 理想气体
    nu = (2/(kappa+1))^(kappa/(kappa-1));
    % 检查是否输入了滞止性质
    if isfield(SOUT, 'StagnantProp')
        p0 = SOUT.StagnantProp.p;
        T0 = SOUT.StagnantProp.T;
        % 计算临界压力
        pc = nu*p0;
        % 计算临界温度、比体积
        Tc = T0*(p0/pc)^((1-kappa)/kappa);
        vc = Rg*Tc/pc;
        % 计算临界流速
        cfc = sqrt(2*kappa/(kappa+1)*Rg*T0);
        % 输出临界参数
        criticalProp.p = pc;
        criticalProp.T = Tc;
        criticalProp.v = vc;
        criticalProp.cf = cfc;
        SOUT.CriticalProp = criticalProp;
    else
        Setlog('[Abort] Absent stagnant properties!');
        return
    end
end
Ready = 1;