function plottomogram(title, source, receiver, N, scale, Plot, opsi_warna, opsi_lingkaran, r)
nGrid = 0:1:N;
[Xplot , Yplot] =  meshgrid(nGrid,nGrid);
Vplot = Plot;
Vplot(N+1, N+1) = 0;
figure('Name', title, 'color', 'white','NumberTitle','off')
axis off;
h = pcolor(Xplot, Yplot, Vplot); hold on;
if opsi_warna == 1
    warna = flipud(hsv);
    scalebar = 'm/s';
    plot(source, receiver,'*r'); hold on;
elseif opsi_warna == 2
    warna = imcomplement(gray);
    scalebar = 'weighting function';
    plot(source, receiver,'*r'); hold on;
elseif opsi_warna == 3
   bwr = @(n)interp1([1 2 3], [0 0 1; 1 1 1; 1 0  0], linspace(1, 3, n), 'linear');
   warna = bwr(128);
   scalebar = 'Resolution (%)';
   plot(source, receiver,'*r'); hold on;
   caxis([-45.45 45.45])
end
colormap(warna);
caxis([0 1]);
ylabel(colorbar, scalebar)
if opsi_warna == 1 || opsi_warna == 2
    xlabel('x (m)'); ylabel('y (m)');
    if opsi_lingkaran == 1
        xlabel('x (grid)'); ylabel('y (grid)');
    end
end
if opsi_lingkaran == 1
    % plot lingkaran 
    ang = 0 :0.001: 1; 
    xp = r*cos(ang*2*pi)+0.5;
    yp = r*sin(ang*2*pi)+0.5;
    plot(r+xp, r+yp ,'linewidth',1,'color','r'); hold on
end
set(gca,'ydir','reverse','xaxislocation','top');
set(h,'EdgeColor','none');
daspect([1 1 1])