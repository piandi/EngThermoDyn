%% example 10-2
% revision 0 by GGQ on 2019-6-20 
clear;
% check file dependancy
prerun;
% get steam properties at status point 1
p1 = 170; T1 = 550; 
p2 = 5/100;
h1 = XSteam('h_pT', p1, T1);
s1 = XSteam('s_pT', p1, T1);
% assume reversible adiabatic expansion
s2 = s1;
h2 = XSteam('h_ps', p2, s2);
% technical work of turbine [kJ/kg]
wt = h1-h2;
% get saturated liquid properties at status point 3
v3 = XSteam('vL_p', p2);
h3 = XSteam('hL_p', p2);
% work of boiler pump [kJ/kg]
wp = (p1-p2)*100*v3;
% get enthalpy of status point 4 with assuming adiabatic compression
h4 = h3+wp;
% get absorption heat and thermal efficiency of cycle
q1 = h1-h4;
eta_t = (wt-wp)/q1;
% output results
fprintf('Technical work of turbine and consuming work of boiler pump are %.1f kJ/kg and %.1f kJ/kg, respectively.\n', wt, wp);
fprintf('Thermal efficiency of cycle is %.3f.\n', eta_t);
fprintf('Specific steam consumption is %.3e kg/kJ.\n', 1/wt);