clear;
syms h h1 h2 qm P T1 T2 Cp;
x={6,30,25,12,276.65,277.15,4.187};
[h1,h2,qm,P,T1,T2,Cp]=deal(x{:});
%Q=deltaH+m/2(c2^2-c1^2)+mg(z2-z1)+Ws,c1=c2
syms deltah q_Q ;
%q_Q=qm[deltah+gh]+P
eq1=deltah==Cp*(T2-T1);
eq2=q_Q==qm*1000*(deltah+9.8*(h1+h2)*10^-3)/3600-P;
[deltah,q_Q]=solve([eq1,eq2],[deltah,q_Q]);
fprintf('有必要加入加热器，且需要加入%.2fkJ/s热量',double(q_Q));


