clear;
syms k b V_0 deltaP;
eq=deltaP==k*V_0+b;
deltaP=[0,0.05];
V_0=[0.3,0.6];
eq1=subs(eq);
[k,b]=solve(eq1);
disp(sprintf('deltaP=%.4fV%.2f \n',double(b),double(k)));
syms P_1 P_2 V_1 V_2 T1 T_2 P W V W_0 W_e;
x={100000,150000,0.3,0.6,290.15};
[P_1,P_2,V_1,V_2,T_1]=deal(x{:});
m=(P_1*V_1)/(287*T_1);
W=10^3*int((0.1667*V-0.05+0.1),V,V_1,V_2);
W_0=P_1*(V_2-V_1)/10^3;
W_e=W-W_0;
T_2=P_2*V_2/(m*287);
Q=m*0.72*(T_2-T_1)+W;
disp(sprintf('(1)过程气体做的功为%.4f J ',double(W)));
disp(sprintf('(2)克服橡皮气球弹力做的功为%.4f J ',double(W_e)));
disp(sprintf('(3)吸热量为%.4f kJ ',double(Q)));





