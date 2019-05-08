clear;
syms Q U W P0 V1 V2 M C;
V1=0.28;V2=0.99;C=61;M=2722;P0=100000;
Q=0;
eq1=W==P0*(V2-V1)+(M*C^2)/2;
eq2=U==Q-W;
[W,U]=solve([eq1,eq2],[W,U]);
fprintf('热力学能变化为 %.2f J ',eval(U));


