function get_limitcycle_bvp(p0)


solinit = bvpinit(linspace(0,1,5),[3; 0.1; 3.5; 0.12; 24]);
options = bvpset('stat','on');
sol = bvp5c(@(t,x) bvp_CNT(t,x,p0,'DD'),@(ya,yb) bc_CNT(ya,yb,p0),solinit,options);

figure;
plot(sol.y(5,:))
LC1 = sol.y


% Find the uncoupled fp as the origin.
fun= @(x) p0(5)*x + p0(6)*x./(.1+x+2*x.^2) - 1./(1+x.^4);
x0= fzero(fun,2); y0= 1./(1+x0.^4);
origin= complex(x0,y0); 

save('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC.mat','LC1','LC2','origin');
