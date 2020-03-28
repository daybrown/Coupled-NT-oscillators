function [Pi]= First_Iterate(p0,mode)

dt= .1;
x= 0:dt:24;
y= 0:dt:24;
[xx,yy]= meshgrid(x,y);

Tmax= length(x);

switch mode
    case 'Pre'
        for i= 1:Tmax
            Pi_pre(i)= map([x(i); x(i)],p0);
            Tmax-i
        end
        figure;
        plot(x,Pi_pre,[0 24],[0 24]);
        axis([0 24 0 24]);
    case 'Full'
        for i= 1:Tmax
            for j= 1:Tmax
                Pi(i,j,:) = map([x(i); y(j)],p0);
                i*j/Tmax^2
            end
        end
%       % Save it.
%       dataname= get_datafile(dt,phi2,alpha1,phi1);
%       save(strcat('C:\Users\liaog\Documents\MATLAB\Coupled_NT_mix\datas\Pi',dataname),'Pi');
        %% Plot surface
        Pi1= Pi(:,:,1)';
        Pi2= Pi(:,:,2)';

        v1= Pi1 - xx;
        v2= Pi2 - yy;
        figure;
        Pi1(abs(gradient(Pi1))>1)= nan;
        surf(xx,yy,Pi1,v1); shading interp
        cmap = [.5 .5 .5
               0.5 0 1];
        ax1= gcf;
        colormap(ax1,cmap);
        % view(ax1,[45 25])
        xlabel('$x_n$'); ylabel('$y_n$'); zlabel('$x_{n+1}$');
        axis tight

        figure;
        [Pi2x,Pi2y]= gradient(Pi2);
        Pi2(abs(Pi2y)>1)= nan;
        surf(xx,yy,Pi2,v2); shading interp
        cmap = [.5 .5 .5
               1 0 0];
        ax2= gcf;
        colormap(ax2,cmap);
        xlabel('$x_n$'); ylabel('$y_n$'); zlabel('$y_{n+1}$');
        axis tight
        
        %% Intersection points
        xslice= abs(Pi1-xx)<1e-1; yslice= abs(Pi2-yy)<1e-1;
        figure;
        plot3(xx(xslice),yy(xslice),Pi1(xslice),'g*',xx(yslice),yy(yslice),Pi2(yslice),'r*');
        %% Contours
        figure;
        Pi1= Pi(:,:,1)';
        Pi2= Pi(:,:,2)';
%         Pi1x = gradient(Pi2);
        [~,Pi2y]= gradient(Pi2);
        Pi1(abs(gradient(Pi1))>1)= nan;
        Pi2(abs(Pi2y)>.5)= nan;
        contour(xx,yy,Pi1-xx,[0 0],'g','linewidth',2);
        hold on;
        contour(xx,yy,Pi2-yy,[0 0],'r','linewidth',2);
        plot(x,y);
        xlabel('x'); ylabel('y');
        legend('$x=\Pi_1(x,y)$','$y=\Pi_2(x,y)$','Diagonal Line');
        hold off;
        end

end