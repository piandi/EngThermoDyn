%% 习题1-12
syms p V;
p1 = 0.2; V1 = 0.4; V2 = 0.8; Vm = 0.6;
% 对闭口系过程pV=const的体积功
p = @(V)(p1*V1/V);
W1 = eval(int(p(V), V, V1, V2));
fprintf('Ans.1: Expansion work of process 1-2 is %.3f MW\n', W1);
% 对闭口系先沿过程p = 0.4-0.5V到Vm后等压变化到V2
p = @(V)(0.4-0.5*V);
W2a = int(p(V), V, V1, Vm);
W2b = int(p(Vm), V, Vm, V2);
W2 = eval(W2a + W2b);
fprintf('Ans.2: Expansion work of process 1-m-2 is %.3f MW\n', W2);