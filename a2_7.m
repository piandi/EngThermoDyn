clear;
syms Q U W P_0 V_1 V_2 M C;
x={0.28,0.99,61,2722,100000};
[V_1,V_2,C,M,P_0]=deal(x{:});
Q=0;
eq1=W==P_0*(V_2-V_1)+(M*C^2)/2;
eq2=U==Q-W;
[W,U]=solve([eq1,eq2],[W,U]);
disp(sprintf('热力学能变化为 %.2f J ',eval(U)));


