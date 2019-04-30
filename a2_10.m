clear;
syms P1 v1 P2 v2  q qm w deltau;
x={100,0.845,800,0.175,139,-50,10};
[P1,v1,P2,v2,deltau,q,c]=deal(x{:});
%闭口系能量方程q=deltau+w
w=q-deltau;
%压气机是开口热力系，压气机耗功wc=-wt。有稳定流动开口系方程q=deltah+wt,得
syms deltah wt 
eq1=deltah==deltau+(P2*v2-P1*v1);
eq2=wt==q-deltah;
[deltah,wt]=solve([eq1,eq2],[deltah,wt]);
%电机功率为N=qm*wt
sym qm;
qm=c/60;
N=qm*wt;
fprintf('(1)对一公斤气体做功为%.2fkJ\n(2)所需技术功为%.2fkJ\n(3)电机功率为%.2fkW',double(abs(w)),double(abs(wt)),double(abs(N)));


