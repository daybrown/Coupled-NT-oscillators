function [LC1,LC2,origin]= get_limitcycle(myfun,x0,p0)
dt= .01;
days= 60;
tf= 24*days;
Tspan= 0:dt:tf;

[t,y]= ode15s(@(t,x) myfun(t,x,p0,'LD'),Tspan,x0);

[~,locs] = findpeaks(y(:,1));
period1= t(locs(end-1)) - t(locs(end-2));
if abs(period1-24) < 1e-1
    LC1= y(end-24/dt:end,1:2);
else
    LC1= y(locs(end-2):locs(end-1),1:2);
end

[~,locs] = findpeaks(y(:,3));
period2= t(locs(end-1)) - t(locs(end-2));
if abs(period2-24) < 1e-1
    LC2= y(end-24/dt:end,3:4);
else
    LC2= y(locs(end-2):locs(end-1),3:4);
end

% Find the uncoupled fp as the origin.
fun= @(x) p0(5)*x + p0(6)*x./(.1+x+2*x.^2) - 1./(1+x.^4);
x0= fzero(fun,2); y0= 1./(1+x0.^4);
origin= complex(x0,y0); 

figure;plot(LC1(:,1),LC1(:,2),'r',LC2(:,1),LC2(:,2),'b--');

save('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC_0815.mat','LC1','LC2','origin','p0');
end