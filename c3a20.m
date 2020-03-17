%% ��ҵ3-20
%
% by Dr. GUAN, Guoqiang @ SCUT on 2020-03-14
%
%% ��ʼ��
clear;
syms x_sym
p = zeros(4,1);
T = zeros(4,1);
h = zeros(4,1);
s = zeros(4,1);
x = zeros(4,1);
Tsat = zeros(4,1);
OH_T = zeros(4,1);
% ����֪״̬ȷ��ˮ��������
p(1) = 30; T(1) = 500;
p(2) = 5; h(2) = 3244;
T(3) = 360; h(3) = 3140;
p(4) = 0.2; x(4) = 0.9;
for i = 1:4
    % ȷ��p��T
    switch i
        case(1)
        case(2)
            T(2) = XSteam('T_ph', p(2), h(2));
        case(3)
            p3_0 = XSteam('psat_T', T(3))*1.2;
            dh = @(p3)(abs(XSteam('h_pT',p3,T(3))-h(3)));
            p3 = fminsearch(dh,p3_0);
            p(3) = p3;
        case(4)
            T(4) = XSteam('Tsat_p',p(4));
    end
    % �ж��Ƿ����
    Tsat(i) = XSteam('Tsat_p',p(i));
    if T(i)>Tsat(i)
        % ��������
        x(i) = NaN;
        h(i) = XSteam('h_pT',p(i),T(i));
        s(i) = XSteam('s_pT',p(i),T(i));
        OH_T(i) = T(i)-Tsat(i);
    else
        % ��������
        h(i) = x(i)*XSteam('hV_p',p(i))+(1-x(i))*XSteam('hL_p',p(i));
        s(i) = x(i)*XSteam('sV_p',p(i))+(1-x(i))*XSteam('sL_p',p(i));
        OH_T(i) = T(i)-Tsat(i);
    end
end
%% ���
table(p,T,h,s,x,OH_T)