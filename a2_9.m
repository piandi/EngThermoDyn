clear;
syms k b V_0 deltaP;
eq=deltaP==k*V_0+b;
deltaP=[0,0.05];
V_0=[0.3,0.6];
eq1=subs(eq);
[k,b]=solve(eq1);
fprintf('deltaP=%.4fV%.2f \n',double(b),double(k));
syms P1 P2 V1 V2 T1 T2 P W V W_0 W_e;
P1=100000;P2=150000;V1=0.3;V2=0.6;T1=290.15;
m=(P1*V1)/(287*T1);
W=10^3*int((0.1667*V-0.05+0.1),V,V1,V2);
W_0=P1*(V2-V1)/10^3;
W_e=W-W_0;
T2=P2*V2/(m*287);
Q=m*0.72*(T2-T1)+W;
fprintf('(1)过程气体做的功为%.4f kJ ',double(W));
fprintf('(2)克服橡皮气球弹力做的功为%.4f kJ ',double(W_e));
fprintf('(3)吸热量为%.4f kJ ',double(Q));





