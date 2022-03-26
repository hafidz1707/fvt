function Silinder3D_Model_custom(title,N,Nh,Smodel,custom)

[Xc,Yc,Zc] = cylinder((N-1)/2,52);
Xc = Xc+11;
Yc = Yc+11;
Xplot = Xc;
Yplot = Yc;
Zplot = Zc;
for i = 1:Nh-1
    Xplot = [Xplot; Xc(2,:)];
    Yplot = [Yplot; Yc(2,:)];
    Zplot = [Zplot; Zc(2,:)+i];
end
Vplot = [];
for row = 1:51
    for column = 1:53
        y = round(Xplot(row,column));
        x = round(Yplot(row,column));
        z = round(Zplot(row,column))+1;
        Vplot(row,column) = 1./(1000*Smodel(x,y,z));
    end
end
%figure('Name', title, 'color', 'white','NumberTitle','off')
%surf(Xplot,Yplot,Zplot,Vplot, 'FaceAlpha', .7);
surf(Xplot,Yplot,Zplot,Vplot);
colormap(custom);
caxis([0 2000]);
scalebar = 'm/s';
xlabel('x (grid)'); ylabel('y (grid)'); zlabel('z (grid)');
ylabel(colorbar, scalebar)
daspect([1 1 1]);
view(3), axis vis3d
camproj perspective, rotate3d on
hold on;
end