clear;
syms V1 V2 P P1 P2 Pb A k b T1 Rg W V mp ma;
x={0.008,290.15,101300,150000,100000,0.08,40000,0.718,287};
[V1,T1,P1,P2,Pb,A,k,b,Rg]=deal(x{:});
%求活塞质量
mp=(P1-Pb)*A/9.8;
%空气质量
ma=P1*V1/(Rg*T1);
h=V1/A;
%终态
x2=((P2-Pb)*A-mp*9.8)/k;
V2=A*(h+x2);
T2=P2*V2/(ma*Rg);
deltaU=ma*b*(T2-T1);
syms x;
P=A*Pb+mp*9.8+k*x;
W=10^-3*int(P,x,0,0.0974);
Q=deltaU+W;
fprintf('所需热量为%.3fkJ /n',double(Q));








