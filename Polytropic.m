%% 计算理想气体多变过程做功及状态变化
% 函数需要类StatePG (< handle)
% 输入参数：多变指数n为0-inf中任意实数
%                   其中n=0、1、kappa和inf分别表示等压、等温、绝热和等容过程
%           初态s1为类StatePG，要求确定各属性
%                   其中通过s1.status中有“已计算”字段校核
%                   压力单位为kPa、温度单位为K、比体积单位为m3/kg
%                   需要类MaterialPG (< handle)，其中比热容等单位为kJ/kg-K
%           终态s2为类StatePG，要求至少给定p-v-T中的一个属性
%                   其中若为等压、等容和等温过程需分别给定p、v和T以外的状态函数
%                   压力单位为kPa、温度单位为K、比体积单位为m3/kg
%                   需要类MaterialPG (< handle)，其中比热容等单位为kJ/kg-K
% 输出参数：w、wt、du和dh分别为体积功、技术功、内能变化和焓变，单位均为kJ/kg
%          终态s2也会在函数返回后更新各属性
%
% by Dr. Guan Guoqiang @ SCUT on 2022-04-14

function [w,wt,du,dh] = Polytropic(n,s1,s2)
    % 检查输入参数数据类型
    if nargin ~= 3
        error('Polytropic()输入参数数量有误!')
    end
    if ~isequal(class(s1),'StatePG') || ~isequal(class(s2),'StatePG')
        error('Polytropic()输入参数数据类型有误！')
    end
    if isempty(strfind(s1.status,'已计算')) % s1应为确定状态
       error('Polytropic()输入初态不确定！')      
    end
    idxUnknown = cellfun(@(x)isempty(x),{s2.p,s2.v,s2.T});
    if sum(~idxUnknown) ~= 1 % s2应知道pvT中的一个
       error('Polytropic()输入终态有误！')
    end
    % 求解绝热过程
    Rg = s1.Material.Rg;
    cv = s1.Material.cv;
    cp = s1.Material.cp;
    kappa = s1.Material.kappa;
    % 初态
    p1 = s1.p;
    v1 = s1.v;
    T1 = s1.T;
    % 终态
    givenVars = [s2.p,s2.v,s2.T];
    syms p2 v2 T2
    assume(T2>0)
    % 确定求解变量
    x = [p2 v2 T2]; xChar = ['p2';'v2';'T2'];
    calcVars = x(idxUnknown);
    calcVarsChar = xChar(idxUnknown,:);
    % 过程方程
    eos = p2*v2 == Rg*T2;
    switch n
        case(0)
            if isequal(calcVarsChar,'p')
                error('定压过程不应给定终态压力条件！')
            end
            peq = T1/v1 == T2/v2;        
        case(1)
            if isequal(calcVarsChar,'T')
                error('定温过程不应给定终态温度条件！')
            end
            peq = p1*v1 == p2*v2;
        case(inf)
            if isequal(calcVarsChar,'v')
                error('定容过程不应给定终态比体积条件！')
            end
            peq = T1/p1 == T2/p2;
        otherwise
            peq = p1*v1^n == p2*v2^n;
    end
    % 代入终态给定的状态变量
    eos2 = subs(eos,x(~idxUnknown),givenVars(~idxUnknown));
    peq2 = subs(peq,x(~idxUnknown),givenVars(~idxUnknown));
    % 求解终态未知变量
    sol = solve([eos2,peq2],calcVars);
    for i = 1:length(calcVars)
        s2.(calcVarsChar(i)) = eval(sol.(calcVarsChar(i,:)));
    end
    if ~isequal(s2.Material.status,'给定')
        s2.Material = s1.Material;
    end
    s2.status = sprintf('理想气体绝热过程已计算');
    % 计算绝热过程做功量
    syms p v
    p2Val = s2.p; v2Val = s2.v; T2Val = s2.T;
    wt = eval(-int((p1/p)^(1/n)*v1,p,p1,p2Val));
    w = eval(int(p1*(v1/v)^n,v,v1,v2Val));
    % 计算绝热过程状态变化量
    du = cv*(T2Val-T1);
    dh = cp*(T2Val-T1);
end