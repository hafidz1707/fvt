function Slice3D_Model(title,xx,yy,zz,Smodel,N,Nh)
Splot = 1./(1000*Smodel);
Splot(N+1,N+1,Nh+1) = 0;
yslice = N;
xslice = [round(N/2),N];
zslice = [0,round(1*Nh/5),round(2*Nh/5),round(3*Nh/5),round(4*Nh/5)];
%zslice = [0,round(2*Nh/5),round(2.33*Nh/5),round(2.66*Nh/5),round(3*Nh/5)];

%warna = [1, 1, 1; 0, 0, 1; 0, 0, 1; 1, 1, 0; 1, 1, 0; 1, 1, 0; 1, 0, 0];

%figure('Name', title, 'color', 'white','NumberTitle','off')
axis off;
slice(xx, yy, zz, Splot, xslice, yslice, zslice);
hold on;
scalebar = 'm/s';
xlabel('x (grid)'); ylabel('y (grid)'); zlabel('z (grid)');
%colormap(flipud(hsv));
%colormap(warna);
colormap(jet);
caxis([1000 2000]);
ylabel(colorbar, scalebar)
daspect([1 1 1]);
view(3), axis vis3d
%set(h,'EdgeColor','none')
camproj perspective, rotate3d on

%{
[x1,y1] = meshgrid(0:N,0:N);
z1 = x1+14;
slice(xx, yy, zz, Splot, x1, y1, z1);
hold on;
caxis([1000 2000]);
scalebar = 'm/s';
xlabel('x (grid)'); ylabel('y (grid)')
%}
