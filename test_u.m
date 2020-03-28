%% Inits.
% clearvars;
% close all;

dt= .1;
days= 3;
tf= 24*days;
Tspan= 0:dt:tf;

phi1= 2.1; phi2= 2.1;
eps1= 0.05; eps2= 0.05;
kD= .05; kf= 1;
%--------------------------------------
kL1= .05; kL2= 0;    % control light
alpha1= 2; alpha2= 0;    % control coupling.
LD_phase= 17.2;    % control light phase
%-----------------------------------------
p0= [phi1;phi2;eps1;eps2;kD;kf;kL1;kL2;alpha1;alpha2;LD_phase];
% x0= [1;1;1.705;0.1548];
x0= [LC1(1721,1);LC1(1721,2);1.721;0.129];

%% Solve
% options= odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@Event_section);
M2 = 0.1:0.01:0.2;
M2_n = M2;
rtime = M2;
for i = 1:length(M2)
    x0(4) = M2(i);
    options= odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@Event_section);
    [t,y,te,ye]= ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0,options);
    M2_n(i) = ye(4);
    rtime(i) = te;
end

figure;
plot(M2,M2_n,'r',[0,0.7],[0,0.7]);

figure;
plot(rtime);

%%
x0(4) = 0.13;
[t,y] = ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0);
figure;
plot(y(:,3),y(:,4));