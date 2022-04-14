%% 混合加热理想循环过程
%
% by Dr. Guan Guoqiang @ SCUT on 2022-04-14

function [w,eta_T] = SabatheCycle(s1,epsilon,lambda,rho)
    if nargin ~= 4
        error('混合加热理想循环Sabathe()输入参数数目有误！')
    end
    if ~isequal(class(s1),'StatePG')
        error('混合加热理想循环Sabathe()输入初态数据类型有误！')
    elseif isempty(strfind(s1.status,'已计算')) % s1应为确定状态
        error('混合加热理想循环Sabathe()输入初态不确定！')      
    end
    % 工质性质
    kappa = s1.Material.kappa;
    % 依次计算各状态
    s(1) = s1;
    % 过程1-2：绝热压缩
    s(2).v = s(1).v/epsilon;
    [w(1),~,du(1),~] = Polytropic(kappa,s(1),s(2));
    q(1) = du(1)+w(1);
    % 过程2-3：定容增压
    s(3).p = s(2).p*lambda;
    [w(2),~,du(2),~] = Polytropic(inf,s(2),s(3));
    % 过程3-4：定压预膨胀
    s(4).v = s(3).v*rho;
    [w(3),~,du(3),~] = Polytropic(0,s(3),s(4));
    % 过程4-5：绝热膨胀
    s(5).v = s(1).v;
    [w(4),~,du(4),~] = Polytropic(kappa,s(4),s(5));
    % 过程5-1：定容减压
    s(6).p = s(1).p;
    [w(5),~,du(5),~] = Polytropic(inf,s(5),s(6));
    % 检查计算结果
    s1Val = [s1.p,s1.v,s1.T];
    s6Val = [s(6).p,s(6).v,s(6).T];
    if norm(s1Val-s6Val) > 1e-8
        warning('混合加热理想循环Sabathe()计算结果偏差大于1e-8！')
    end
    % 循环做功量
    wc = sum(w);
    % 循环热量
    q = du+w;
    q1 = sum(q(q>0)); % 吸热量
    q2 = sum(q(q<0)); % 放热量
    % 循环热效率
    eta_T = 1-abs(q2/q1);
end