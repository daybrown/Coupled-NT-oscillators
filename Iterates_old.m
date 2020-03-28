dt= .1;
x= 0:dt:24;
y= 0:dt:24;
% ss= zeros(Tmax,Tmax,2);
[xx,yy]= meshgrid(x,y);
% ss(:,:,1)= xx;
% ss(:,:,2)= yy;
Tmax= length(x);
%% Iterates. Run intialization first.
Pi= zeros(Tmax,Tmax,2);
count= Tmax*Tmax;
% CNT_map([2 12])

% for alpha= [1.5 2 2.5]
% for phi2= [1.9 2 2.3]

% for i= 1:Tmax
%     Pi_pre(i)= map([x(i) x(i)]);
%     Tmax-i
% end
% figure;
% plot(x,Pi_pre,[0 24],[0 24]);
% % plot(x,Pi_pre);
% axis([0 24 0 24]);

% end

% global alpha1
    
for i= 1:Tmax
    for j= 1:Tmax
        Pi(i,j,:) = map([x(i) y(j)]);
%         Pi(i,j,:) = CNT_map([x(i) y(j)]);
        count= count - 1
    end
end
% Save it.

dataname= get_datafile(dt,phi2,alpha1,phi1);
save(strcat('C:\Users\liaog\Documents\MATLAB\Coupled_NT_mix\datas\Pi',dataname),'Pi');

% end
%% Plots
Pi1= Pi(:,:,1)';
Pi2= Pi(:,:,2)';
% [x,y,z] = meshgrid(linspace(0,24,30));
% v = x.^2 + y.^2 + z.^2;
% % Define the diagonal slice plane
% [xi, zi] = meshgrid(linspace(0,24,50));
% yi = xi;

v1= Pi1 - xx;
% Pi2= round(Pi2,2);
v2= Pi2 - yy;
figure;
% ax1= subplot(1,2,1);
Pi1(abs(gradient(Pi1))>1)= nan;
surf(xx,yy,Pi1,v1); shading interp
cmap = [.5 .5 .5
       0.5 0 1];
ax1= gcf;
colormap(ax1,cmap);
% view(ax1,[45 25])
xlabel('$x_n$'); ylabel('$y_n$'); zlabel('$x_{n+1}$');
axis tight
% legend('$\Pi_1$');
% plot3(xx(v1>0),yy(v1>0),Pi1(v1>0),'b*',xx(v1<0),yy(v1<0),Pi1(v1<0),'r*');
% surf(xx(v1>0),yy(v1>0),Pi1(v1>0)); hold on;
% surf(xx(v1<0),yy(v1<0),Pi1(v1<0));
% hold on;
% slice(v,xi,yi,zi);

% ax2= subplot(1,2,2);
figure;
[Pi2x,Pi2y]= gradient(Pi2);
Pi2(abs(Pi2y)>1)= nan;
surf(xx,yy,Pi2,v2); shading interp
cmap = [.5 .5 .5
       1 0 0];
ax2= gcf;
colormap(ax2,cmap);
xlabel('$x_n$'); ylabel('$y_n$'); zlabel('$x_{n+1}$');
axis tight
% legend('$\Pi_2$');
% plot3(xx(v2>0),yy(v2>0),Pi2(v2>0),'bo',xx(v2<0),yy(v2<0),Pi2(v2<0),'ro');
% hold on;
% slice(v,xi,yi,zi);

% figure;
% judge= abs(diat) < 1e-4;
% plot3(xx(judge),yy(judge),Pi1(judge),'g',xx(judge),yy(judge),Pi2(judge),'k');
% 
% figure;
% plot(xx(judge),Pi1(judge),'g',xx(judge),Pi2(judge),'k');

%%
xslice= abs(Pi1-xx)<1e-1; yslice= abs(Pi2-yy)<1e-1;
figure;
plot3(xx(xslice),yy(xslice),Pi1(xslice),'g*',xx(yslice),yy(yslice),Pi2(yslice),'r*');
%%
figure;
Pi1= Pi(:,:,1)';
Pi2= Pi(:,:,2)';
Pi1(abs(gradient(Pi1))>.5)= nan;
[Pi2x,Pi2y]= gradient(Pi2);
Pi2(abs(Pi2y)>.5)= nan;
contour(xx,yy,Pi1-xx,[0 0],'color',[0.5 0 1],'linewidth',2);
hold on;
contour(xx,yy,Pi2-yy,[0 0],'r','linewidth',2);
plot(x,y,'k');
set(gca,'XTick',0:4:24,'YTick',0:4:24)
xlabel('x'); ylabel('y');
legend('$x=\Pi_1(x,y)$','$y=\Pi_2(x,y)$','Diagonal Line');
hold off;
%% Iterate the map for entrainment time.
Pi1_a= round(Pi(:,:,1),1);
Pi2_a= round(Pi(:,:,2),1);    % approximate the data to dt=.1, because of our mesh grid.
Tmax= length(0:dt:24);
Pi_iterate= zeros(Tmax,Tmax);

x1_star= 6.2; x2_star= 6.2;  %7.1 for \phi_2=7.3, 9.1 for \phi_2=7.15, 10.1 for \phi_2=7.05
                             % 8.24 for alpha=2.5; 10.245 for alpha=1.5   

count= Tmax^2;

for i= 1:Tmax
    for j= 1:Tmax
        x1= (i-1)*dt; x2= (j-1)*dt;
        x1_n= Pi1_a(i,j);  x2_n= Pi2_a(i,j);
%         num= 1;
%         AA(num,1)= x1_n;  AA(num,2)= x2_n;
        iternum= 0;
        Tr_sum= 0;
        Tr_sum= Tr_sum + 24 + Pi2(i,j) - x2;
        
        while (pdist([x1_n x2_n;x1_star x2_star]) > .5) && (iternum<70)           
            x1= x1_n; x2= x2_n;
            i_n= round(x1_n/dt + 1); j_n= round(x2_n/dt + 1);
            x1_n= Pi1_a(i_n,j_n);  x2_n= Pi2_a(i_n,j_n);
%             num= num + 1;
%             AA(num,1)= x1_n;  AA(num,2)= x2_n;
            iternum= iternum + 1;
            Tr_sum= Tr_sum + 24 + Pi2(i_n,j_n) - x2;
        end
        
        if iternum >= 70
            Pi_iterate(i,j)= nan;
        else
            Pi_iterate(i,j)= Tr_sum;
        end
        count= count - 1
%         Pi_iterate(i,j)
    end
end

figure;
pcolor(xx,yy,Pi_iterate'); shading interp
xlabel('x'); ylabel('y'); legend('Times of iterations');

% figure;
% heatmap(Pi_iterate);
%% Calculation vector field like flow.
% Round up
Pi1_a= round(Pi(:,:,1),1);
Pi2_a= round(Pi(:,:,2),1);
% IC
N= 10;
x1=zeros(N,1);  x2=zeros(N,1);
% x1(1)= 4.6;   x2(1)= 14.5;
figure;
for xv= 0:dt*10:24
    for yv= 0:dt*10:24
% Iteration of the map
x1(1)= xv;   x2(1)= yv;
for k= 2:N
    a= round(x1(k-1)/dt + 1);    b= round(x2(k-1)/dt + 1);
    x1(k)= Pi1_a(a,b);
    x2(k)= Pi2_a(a,b);
end
% plot(x1,x2,'.');
dx1= ones(N,1); dx2= ones(N,1);
dx1(1:N-1)= x1(2:end)-x1(1:end-1);  dx2(1:N-1)= x2(2:end)-x2(1:end-1);
L= sqrt(dx1.^2+dx2.^2);
for s= 1:length(L)
    if L(s)>15
        L(s)=-L(s);
    end
end
quiver(x1,x2,dx1./L/1,dx2./L/1,0,'k','LineWidth',2);
% quiver(x1,x2,dx1./L/2,dx2./L/2,0,'LineWidth',2,'Color',rand(1,3));
% labels=  cellstr(num2str([1:N]'));
% text(x1,x2,labels);
% plot(x1,x2,'*');
hold on;
    end
end
title(['x = ',num2str(x1(1)),', y = ',num2str(x2(1))]);
xlabel('x');    ylabel('y');
axis([-1 25 -1 25]);

%% animation
close all;
h = animatedline('Color','r','LineWidth',2);
hold on;
axis([0 24 0 24]);
for k = 1:N
    addpoints(h,x1(k),x2(k));
    head1= scatter(x1(k),x2(k),'filled','Markerfacecolor','r');
    drawnow
    pause(.1);
    delete(head1);
end
hold off;

%% Iterate the map
N= 8;

figure;

for xv= 4%0:dt*10:24
    for yv= 12%0:dt*10:24
        Iterpt= zeros(N,2);
        Iterpt(1,:)= [xv yv];
        for n= 1:N-1
            Iterpt(n+1,:)= map(Iterpt(n,:)',p0);
        end
%     figure;
%     plot(Iterpt(:,1),Iterpt(:,2));
    dxy= Iterpt(2:end,:) - Iterpt(1:end-1,:);
    dxy= cat(1,dxy,[0 0]);
    dx= dxy(:,1);  dy= dxy(:,2);
% dx0= ones(1,N); dy0= ones(1,N);
% dx0(1:N-1)= x0(2:end)-x0(1:end-1);  dy0(1:N-1)= y0(2:end)-y0(1:end-1);
% L= sqrt(dx0.^2+dy0.^2);
    L= sqrt(dx.^2+dy.^2);
    for s= 1:length(L)
        if L(s)>15
            L(s)=-L(s);
        end
    end
%     quiver(Iterpt(:,1),Iterpt(:,2),dx./L/1,dy./L/1,0,'LineWidth',2,'Color',rand(1,3));
    quiver(Iterpt(:,1),Iterpt(:,2),dx./L/1,dy./L/1,0,'k','LineWidth',1.5);
    labels=  cellstr(num2str([1:N]'));
    text(Iterpt(:,1),Iterpt(:,2),labels,'FontSize',20);
%     quiver(Iterpt(2:end,1),Iterpt(2:end,2),dx(2:end)./L(2:end)/1,dy(2:end)./L(2:end)/1,0,'k','LineWidth',1.5);
%     labels=  cellstr(num2str([2:N]'));
%     text(Iterpt(2:end,1),Iterpt(2:end,2),labels,'FontSize',20);
    hold on;
    end
end
title(['x=',num2str(xv),', y=',num2str(yv)]);
grid on;
axis([-1 25 -1 25]);

%% Use the idea of vector field.
Pi1= Pi(1:5:241,1:5:241,1)';
Pi2= Pi(1:5:241,1:5:241,2)';
[xx1,yy1]= meshgrid(0:.5:24,0:.5:24);

% Pi1= Pi(1:241,1:241,1)';
% Pi2= Pi(1:241,1:241,2)';
% [xx1,yy1]= meshgrid(0:.1:24,0:.1:24);

Dx= Pi1 - xx1; Dy= Pi2 - yy1;
L= sqrt(Dx.^2+Dy.^2);

Logi= L > 15;
L(Logi)= -L(Logi);

figure;
q= quiver(xx1,yy1,Dx./L/5,Dy./L/5,0,'LineWidth',2);
axis([-1 25 -1 25]);