function Sudut = PlotGarisRaypath(N,rmod,GradientTravelTime,Smodel)

nGrid = 0:1:N;
[Xplot , Yplot] =  meshgrid(nGrid,nGrid);
Vplot = 1./(1000*Smodel);
Vplot(N+1, N+1) = 0;
figure('Name', 'Plot Garis Raypath', 'color', 'white','NumberTitle','off')
axis off;
h = pcolor(Xplot, Yplot, Vplot); hold on;

warna = flipud(hsv);
scalebar = 'm/s';

colormap(warna);
ylabel(colorbar, scalebar);
xlabel('x (grid)'); ylabel('y (grid)');
ang = 0 :0.001: 1; 
xp = rmod*cos(ang*2*pi)+0.5;
yp = rmod*sin(ang*2*pi)+0.5;
plot(rmod+xp, rmod+yp ,'linewidth',1,'color','w'); hold on
set(gca,'ydir','reverse','xaxislocation','top');
set(h,'EdgeColor','none');
daspect([1 1 1])


r = 1;
for i = 1:4:N
    for j = 1:4:N
        if Smodel(j,i) < 1/(341*1000)
            u = r * cos(GradientTravelTime(j,i));
            v = r * sin(GradientTravelTime(j,i));
            quiver(i,j,u,v,2,'k');
            hold on;
        end
    end
end

end