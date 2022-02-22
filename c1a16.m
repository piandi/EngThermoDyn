%% œ∞Ã‚1-16
clear;
syms p V;
V1 = 0.1; V2 = 0.25; pa = 0.1; friction = 1200; area = 0.1;
p = @(V)(0.24-0.4*V);
Wexp = int(p(V), V, V1, V2);
fprintf('Ans.1: expansion work is %.3g MJ.\n', eval(Wexp));
Weff = int(p(V)-pa-friction/area/1e6, V, V1, V2);
fprintf('Ans.2: effective work is %.3g MJ.\n', eval(Weff));
Wuti = int(p(V)-pa, V, V1, V2);
fprintf('Ans.3: effective work with ignored friction is %.3g MJ.\n', ...
    eval(Wuti));