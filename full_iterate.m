function [Pi_iter] = full_iterate(p0,xs)

dt= .1;
x= 0:dt:24;
y= 0:dt:24;
[xx,yy]= meshgrid(x,y);
Tmax= length(x);

Pi_iter= zeros(Tmax,Tmax);

count= Tmax^2;

for i= 1:Tmax
    for j= 1:Tmax
        X= [x(i); y(j)];
        X_new= map(X,p0);
        
        iternum= 0;
        Tr_sum= 0;
        Tr_sum= Tr_sum + X_new(3);        
        while (norm(X_new(1:2)'-xs) > .5) && (iternum<70)           
            X= X_new;
            X_new= map(X(1:2)',p0);
            iternum= iternum + 1;
            Tr_sum= Tr_sum + X_new(3);
        end
        
        Pi_iter(i,j)= Tr_sum;
        count= count - 1
    end
end

save('C:\Users\liaog\Documents\MATLAB\CNT_final\datas\Pi_iterate.mat','Pi_iter');

%%
figure;
pcolor(yy,xx,Pi_iter), shading interp
xlabel('x'); ylabel('y');
axis([0 24 0 24]);
legend('E-time');

end