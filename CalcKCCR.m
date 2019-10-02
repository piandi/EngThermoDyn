function [SOUT, Ready] = CalcKCCR(SIN)
%% Calculate kappa, cp, cv and Rg according to 2 of them
%
% by Dr. GUAN Guoqiang @ SCUT on 2019/10/1
%
%%
% 初始化
SOUT = SIN;
Ready = 0;
% 检查kappa, cp, cv和Rg中至少输入两个
varChk = [isfield(SOUT, 'kappa'), isfield(SOUT, 'cp'), ...
          isfield(SOUT, 'cv'), isfield(SOUT, 'Rg')];
if sum(varChk) >= 2
    Ready = 1;
    if (varChk(1) == 1 && varChk(2) == 1); method = 1; end
    if (varChk(1) == 1 && varChk(3) == 1); method = 2; end
    if (varChk(1) == 1 && varChk(4) == 1); method = 3; end
    if (varChk(2) == 1 && varChk(3) == 1); method = 4; end
    if (varChk(2) == 1 && varChk(4) == 1); method = 5; end
    if (varChk(3) == 1 && varChk(4) == 1); method = 6; end
    switch method
        case 1
            Setlog('Fill properties according to kappa and cp.');
            SOUT.cv = SOUT.cp/SOUT.kappa;
            SOUT.Rg = SOUT.cp-SOUT.cv;
        case 2
            Setlog('Fill properties according to kappa and cv.');
            SOUT.cp = SOUT.cv*SOUT.kappa;
            SOUT.Rg = SOUT.cp-SOUT.cv;
        case 3
            Setlog('Fill properties according to kappa and Rg.');
            SOUT.cv = SOUT.Rg/(SOUT.kappa-1);
            SOUT.cp = SOUT.cv+SOUT.Rg;
        case 4
            Setlog('Fill properties according to cp and cv.');
            SOUT.Rg = SOUT.cp-SOUT.cv;
            SOUT.kapp = SOUT.cp/SOUT.cv;
        case 5
            Setlog('Fill properties according to cp and Rg.');
            SOUT.cv = SOUT.cp-SOUT.Rg;
            SOUT.kappa = SOUT.cp/SOUT.cv;
        case 6
            Setlog('Fill properties according to cv and Rg.');
            SOUT.cp = SOUT.cv+SOUT.Rg;
            SOUT.kappa = SOUT.cp/SOUT.cv;
    end
else
    Ready = 0;
    Setlog('[Error] 2 of 4 variables (kappa, cp, cv and Rg) are required!');  
end