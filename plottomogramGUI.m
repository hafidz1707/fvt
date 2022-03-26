function Smodel = plottomogramGUI(N, Sawal)

Smodel = zeros(N,N);
Smodel(:,:) = 1/(340*1000); % Kecepatan Udara
rmod = (N-1)/2;
for i = 1:N
    for j = 1:N
        jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
        jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
        if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
            Smodel(j,i) = 1/(Sawal*1000);
        end    
    end
end

nGrid = 0:1:N;
[Xplot , Yplot] =  meshgrid(nGrid,nGrid);
Vplot = 1./(1000*Smodel);
Vplot(N+1, N+1) = 0;
figure;
axis off;
h = pcolor(Xplot, Yplot, Vplot); hold on;
colormap(flipud(hsv));
%caxis([0 3500]);
ylabel(colorbar, scalebar)
xlabel('x (grid)'); ylabel('y (grid)');


ang = 0 :0.001: 1; 
xp = rmod*cos(ang*2*pi)+0.5;
yp = rmod*sin(ang*2*pi)+0.5;
plot(rmod+xp, rmod+yp ,'linewidth',1,'color','w'); hold on

set(gca,'ydir','reverse','xaxislocation','top');
set(h,'EdgeColor','none');
daspect([1 1 1])