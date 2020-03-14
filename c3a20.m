%% 作业3-20
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-14
%
%% 初始化
clear;
syms x_sym
p = zeros(4,1);
T = zeros(4,1);
h = zeros(4,1);
s = zeros(4,1);
x = zeros(4,1);
Tsat = zeros(4,1);
OH_T = zeros(4,1);
% 由已知状态确定水蒸气性质
p(1) = 30; T(1) = 500;
p(2) = 5; h(2) = 3244;
T(3) = 360; h(3) = 3140;
p(4) = 0.2; x(4) = 0.9;
for i = 1:4
    % 确定p和T
    switch i
        case(1)
        case(2)
            T(2) = XSteam('T_ph', p(2), h(2));
        case(3)
            p3 = XSteam('psat_T', T(3))*1.2;
            DoWhileLoop = 1;
            while DoWhileLoop
                s3 = XSteam('s_ph', p3, h(3));
                p3_new = XSteam('p_hs', h(3), s3);
                if abs(p3-p3_new) < 1e-5
                    DoWhileLoop = 0;
                else
                    DoWhileLoop = 1;
                end
                p3 = p3_new;
            end
            p(3) = p3;
        case(4)
            T(4) = XSteam('Tsat_p',p(4));
    end
    % 判定是否过热
    Tsat(i) = XSteam('Tsat_p',p(i));
    if T(i)>Tsat(i)
        % 过热蒸汽
        x(i) = NaN;
        h(i) = XSteam('h_pT',p(i),T(i));
        s(i) = XSteam('s_pT',p(i),T(i));
        OH_T(i) = T(i)-Tsat(i);
    else
        % 饱和蒸汽
        h(i) = x(i)*XSteam('hV_p',p(i))+(1-x(i))*XSteam('hL_p',p(i));
        s(i) = x(i)*XSteam('sV_p',p(i))+(1-x(i))*XSteam('sL_p',p(i));
        OH_T(i) = T(i)-Tsat(i);
    end
end
%% 输出
table(p,T,h,s,x,OH_T)