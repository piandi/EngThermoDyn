clear;
%dQ=0;dW_i=0;dm2=0;c_f1=0;z_2=0;z_1=0;
%dE_CV==dQ-(dm2*(h_2+0.5*c_2^2+9.8*z_2)-dm1*(h_1+0.5*c_1^2+9.8*z_1)+dW_i);
syms m1 m2 u1 u2 T2 T1 Cv Cp P1 P2 V1 V2 Rg ;
P1=100000;P2=200000;V1=0.028;V2=0.028;T1=294.15;Rg=287;Cp=1.005;Cv=0.72;
m1=(P1*V1)/(Rg*T1);
u1=Cv*T1;
u2=Cv*T2;
h_1=(m2*u2-m1*u1)/(m2-m1);
eq1=T2==(Cp*T1*(m2-m1)+m1*Cv*T1)/(m2*Cv);
eq2=m2==P2*V2/(Rg*T2);
[m2,T2]=solve([eq1,eq2],[m2,T2]);
fprintf('平衡时的温度为%.2f K,质量为%.4f kg ',double(T2),double(m2));



