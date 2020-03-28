function X = map(xint,p0)   % (x_{n+1},y_{n+1})=Pi(x_n,y_n).

dt= .01;
days= 2;
t0= 0; tf= 24*days;
Tspan= t0:dt:tf;

x= xint(1,:);
y= xint(2,:);

p0(11)= y;
load('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC','LC1','origin');
% load('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC_symetric','LC1','origin');
% load('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC_asym','LC1','origin');
% load('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\CNT_LC_0815_kL2_025','LC1','origin');

xs= round(x/dt+1);
IC= [LC1(xs,1:2) 1.705 0.1548]';
% IC= [LC1(xs,1:2) 1.7493 0.1546]';  % alpha1=alpha2=2
% IC= [LC1(xs,1:2) 1.8478 0.1256]';   % kL2=0,alpha2=0.5
% IC= [LC1(xs,1:2) 1.8478 0.123]';   % kL2=0,alpha2=2
% IC= [LC1(xs,1:2) 1.8013 0.14122]';   % kL2=0.025,alpha2=0
options= odeset('AbsTol',1e-8,'RelTol',1e-8,'Events',@Event_section);
[~,Y,TE,YE,~]= ode15s(@(t,x) model_CNT(t,x,p0,'LD'),Tspan,IC,options);

%% Pi_1
% Angle idea.
xoz= origin;

   % vector correspond to limit cycle. The origin is changed to xf.
z_lc= complex(LC1(:,1),LC1(:,2)) - xoz;     % Trans to complex numbers.
zn_lc= z_lc.*exp(-i*angle(z_lc(1)));     % Rotate the axis.
thetan_lc= radtodeg(angle(zn_lc));
% Change to [0,2pi].
ind1= find(thetan_lc < 0);
ind2= find(thetan_lc > 1e-8);
thetan_lc(ind1)= -thetan_lc(ind1);
thetan_lc(ind2)= 360 - thetan_lc(ind2);

u0= zn_lc(xs);     % the initial phase.
xe= complex(YE(1,1),YE(1,2));
xen= (xe-xoz).*exp(-i*angle(z_lc(1)));  % Rotate it to the reference axis.
theta_xen= radtodeg(angle(xen));
% Change to [0,2pi].
if theta_xen > 1e-8
    theta_xen= 360 - theta_xen;
else
    theta_xen= - theta_xen;
end

theta_diff= abs(thetan_lc-theta_xen);
[~,idx]= sort(theta_diff);

%---------Find the changing angle by Determine the times
%---------of crossing branch cut.
k= 1;
if (x >= 12) && (abs(theta_xen-thetan_lc(xs)) > 180)
    k= 2;
end
if (x <= 12) && (abs(theta_xen-thetan_lc(xs)) > 180)
    k= 0;
end

dtheta= theta_xen - thetan_lc(xs) + k*360;
dtime= (idx(1)-1)*dt - x + k*24;
%----------------------------------------------------------------

% Use modulus to define Pi_1.
un= xint(1,:)+dtime;    % the value without mod.

u= (idx(1)-1)*dt;

% Pi_2
% TE(1)
vn= y+TE(1);    % the value without mod.
v= mod(y + TE(1),24);

X= v;   % For pre map.
% X= TE(1);   % For return time.
% X = [un vn];
% X= [u v];

% X= [u v TE(1)];  % In case of return time.
end