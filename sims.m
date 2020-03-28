%% Inits.
% clearvars;
% close all;

dt= .1;
days= 10;
tf= 24*days;
Tspan= 0:dt:tf;

phi1= 2.1; phi2= 2.1;
eps1= 0.05; eps2= 0.05;
kD= .05; kf= 1;
%--------------------------------------
kL1= .05; kL2= 0;    % control light
alpha1= 2; alpha2= 0;    % control coupling.
LD_phase= 0;    % control light phase
%-----------------------------------------
p0= [phi1;phi2;eps1;eps2;kD;kf;kL1;kL2;alpha1;alpha2;LD_phase];
x0= [4.37;0.2685;1.705;0.1548];
% x0= [LC1(631,1:2) 1.8013 0.14122]';
% x0= [LC1(1,1);LC1(1,2);1.705;0.1548];
% x0= [LC1(1021,1:2) 1.8478 0.1256]'; 

%% Solve
options= odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@Event_section);
% options= odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@Event_Tperiod);
[t,y,TE,YE]= ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0,options);
% [t,y]= ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0);
returntime = TE(2:end) - TE(1:end-1);
%% Plots
figure;
plot(y(:,1),y(:,2),'r',y(:,3),y(:,4),'b--');
figure;
plot(y(end-240:end,1),y(end-240:end,2),'r',y(end-240:end,3),y(end-240:end,4),'b--');

%%
[lc1,lc2,ori]= get_limitcycle(@model_CNT,x0,p0);