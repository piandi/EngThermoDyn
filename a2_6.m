clear;
syms m p V Rg T Q W;
p=100000;V=45;Rg=287;T=301.15;
m=(p*V)/(Rg*T);
%取室内空气为系统，Q=deltaU+W,W=0, deltaU=Q
Q=(0.1+0.06)*3600+418.7*3-1800;
deltaT=Q/(0.72*52.06);
fprintf('每小时温度升高值为%.3fK',double(deltaT));
