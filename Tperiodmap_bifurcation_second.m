function Tperiodmap_bifurcation_second(p0,idx)
% p0: the parameter of the system.
% idx: the idx th p0 to bifurcate.

x0 = [4.37;0.2685;1.721;0.129];
dt = 0.1;
Tspan = 0:dt:2400;

maxp = 6;
step = 0.01;
count = 1;

for i = 0:step:maxp
    p0(idx) = i;
    [t,y] = ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0);
    x0 = y(end,:);
    rup(count) = norm(x0);
    count = count + 1;
end

count = count - 1;
for i = maxp:-step:0
    p0(idx) = i;
    [t,y] = ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,x0);
    x0 = y(end,:);
    rdown(count) = norm(x0);
    count = count - 1;
end

figure;
hold on;
plot(0:step:maxp,rup,'r.');
plot(0:step:maxp,rdown,'r.');
hold off;

