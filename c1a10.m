%%œ∞Ã‚10
clear;
syms P F;
eq1 = P == F*2;
eq2 = F == 450*9.8;
[P, F] = solve([eq1, eq2], [P, F]);
disp(sprintf('power is %.3f W ', eval(P)))
