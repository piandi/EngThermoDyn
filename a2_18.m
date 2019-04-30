clear;
syms dQ dE_CV h_1 h_2 c_1 c_2 z_1 z_2 dm_1 dm_2 dW_i;
dQ=0;dW_i=0;dm_2=0;c_f1=0;z_2=0;z_1=0;
eq=dE_CV==dQ-(dm_2*(h_2+0.5*c_2^2+9.8*z_2)-dm_1*(h_1+0.5*c_1^2+9.8*z_1)+dW_i);
[dE_CV]=solve(eq)
syms m_1 m_2 u_1 u_2 T_2 T_1 C_V C_P P_1 P_2 V_1 V_2 R_g ;
x={100000,200000,0.028,0.028,294.15,287,1.005,0.72};
[P_1,P_2,V_1,V_2,T_1,R_g,C_P,C_V]=deal(x{:});
m_1=(P_1*V_1)/(R_g*T_1);
u_1=C_V*T_1;
u_2=C_V*T_2;
h_1=(m_2*u_2-m_1*u_1)/(m_2-m_1);
eq1=T_2==(C_P*T_1*(m_2-m_1)+m_1*C_V*T_1)/(m_2*C_V);
eq2=m_2==P_2*V_2/(R_g*T_2);
[m_2,T_2]=solve([eq1,eq2],[m_2,T_2]);
disp(sprintf('平衡时的温度为%.2f K,质量为%.4f kg ',double(T_2),double(m_2)));



