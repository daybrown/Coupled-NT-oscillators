function [phik,phik1] = Bisection_step(W,d_range,alpha_range,dalpha_range)

% Parameters have same meaning as Grow_manifold.

N= length(W(:,1));
phik= []; phik1= [];


for i= N:-1:2
%     for tao= 0:0.1:1
%          phi_tao= (1-tao)*W(i-1,:) + tao*W(i,:);
     fp_left= map(W(i-1,:)) - 24;
     fp_right= map(W(i,:)) - 24;
    %          v_lc= W(end,:) - W(end-1,:);
     d_left= norm(fp_left-W(end,:)) - d_range(2);
     d_right= norm(fp_right-W(end,:)) - d_range(2);

     if (d_left <= 0) && (d_right <= 0)  % Accept if both end points is inside the circle.
         phik= W(i,:);
         phik1= map(phik) - 24;
         return
     end

     if (d_left > 0) && (d_right > 0)
         continue   % Not the right line segment, search next.
     end

     % Use bisection.
     p_left= W(i-1,:);
     p_right= W(i,:);
     while (norm(p_left-p_right) > 1e-2)
         phi_tao= (p_left+p_right)/2;
         phi_tao(1)= round(phi_tao(1),3);   % The accuracy is limited by the acc. of the limit cycle.
         phi2= map(phi_tao);    % Use the map without mod.
         phi2= phi2 - 24;   % Get the right point in phase space.
         phi_bar= W(end,:) + (W(end,:)-phi2)/norm(W(end,:)-W(end-1,:));
         alpha= norm(phi_bar-W(end-1,:))/norm(W(end,:)-W(end-1,:));
         dk= norm(W(end,:)-phi2);
         if (dk<1.2*d_range(2)) && (dk>d_range(1)) && (alpha<alpha_range) && (dk*alpha<dalpha_range)
        %             if (alpha<alpha_range(1)) && (dk*alpha<dalpha_range(1))
        %                 dk= 2*dk;
        %             end
            phik= phi_tao;
            phik1= phi2;
            return  % Find the new point, free to go!
         end
         
         if (d_left*(norm(phi2-W(end,:))-d_range(2)) < 0)
             p_right= phi_tao;
         else
             p_left= phi_tao;
             d_left= norm(phi2-W(end,:))-d_range(2);
         end             
     end
     % if bisection didn't find it, then accept the last one anyway
     phik= phi_tao;
     phik1= phi2;     
     return
end

if isempty(phik) || isempty(phik1)
    phik= W(end,:);
    phik1= map(phik) - 24;
end

end
