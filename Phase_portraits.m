% Load the data at the beginning.

%% get the iterates of phase portraits.
N= 10;

figure;

for xv= 0:dt*10:24
    for yv= 0:dt*10:24
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
    quiver(Iterpt(:,1),Iterpt(:,2),dx./L/1,dy./L/1,0,'k','LineWidth',2);
%     labels=  cellstr(num2str([1:N]'));
%     text(Iterpt(:,1),Iterpt(:,2),labels,'FontSize',20);
%     plot(Iterpt(:,1),Iterpt(:,2),'b*');
    hold on;
    end
end
title(['x=',num2str(xv),', y=',num2str(yv)]);
grid on;
axis([-1 25 -1 25]);

%% Get the vector field of the map.
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