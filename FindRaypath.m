function GarisRaypath = FindRaypath(N,h,posisi_S_ray,posisi_R_ray,Gradient)

GarisRaypath = zeros(N,N);
% Pertama, mencari Lij dari arah receiver
ffgrid = [floor(posisi_S_ray(1,1)), floor(posisi_S_ray(1,2))];
finalgrid = floor(posisi_S_ray(1,1)) + (floor(posisi_S_ray(1,2))-1)*N;
zadummy = posisi_S_ray(1,1);
xadummy = posisi_S_ray(1,2);
zi = floor(posisi_S_ray(1,1));
xi = floor(posisi_S_ray(1,2));
za = zadummy;
xa = xadummy;

% Lasli = sqrt( (posisi_R_ray(1,1) - posisi_S_ray(1,1))^2 + (posisi_R_ray(1,2)-posisi_S_ray(1,2))^2);

for abc = 1:2
    theta = Gradient(floor(za),floor(xa));
    x1 = xi; % x kiri
    x2 = xi+h; % x kanan
    z1 = zi; % z atas
    z2 = zi+h; % z bawah
    theta1 = atan((z2-za)/(x2-xa));
    theta2 = atan((xa-x1)/(z2-za)) + (pi/2);
    theta3 = atan((za-z1)/(xa-x1)) + (pi);
    theta4 = atan((x2-xa)/(za-z1)) + (1.5*pi);
    arah = 1;
    if theta > theta4 || theta < theta1
        xa2 = xi+h;
        za2 = za + (xi+h - xa) * tan(theta);
        arah = 1; % ke kanan
        nextgrid = [zi, xi+h];
    elseif theta == theta1
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % ke kanan bawah
        nextgrid = [zi+h, xi+h];
    elseif theta > theta1 && theta < theta2
        xa2 = xa + (zi+h - za) * cot(theta);
        za2 = zi+h;
        arah = 3; % ke bawah
        nextgrid = [zi+h, xi];
    elseif theta == theta2
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % ke kiri bawah
        nextgrid = [zi+h, xi-h];
    elseif theta > theta2 && theta < theta3
        xa2 = xi;
        za2 = za + (xi - xa) * tan(theta);
        arah = 5; % ke kiri
        nextgrid = [zi, xi-h];
    elseif theta == theta3
        xa2 = xi;
        za2 = za;
        arah = 6; % ke kiri atas
        nextgrid = [zi-h, xi-h];
    elseif theta > theta3 && theta < theta4
        xa2 = xa + (zi - za) * cot(theta);
        za2 = zi;
        arah = 7; % ke atas
        nextgrid = [zi-h, xi];
    elseif theta == theta4
        xa2 = xi+h;
        za2 = zi;
        arah = 8; % Ke kanan atas
        nextgrid = [zi-h, xi+h];
    end
    
    GarisRaypath(zi,xi) = sqrt((xa2-xa)^2 + (za2-za)^2);
    
    % Memulai dari 
    za = posisi_R_ray(1,1);
    xa = posisi_R_ray(1,2);
    zi = floor(posisi_R_ray(1,1));
    xi = floor(posisi_R_ray(1,2));
    nextgrid2 = nextgrid(1,1) + (nextgrid(1,2)-1)*N;
    % arah
end
%% Menuju Looping untuk mencari raypath!!!
while finalgrid ~= nextgrid2
    theta = Gradient(ceil(za2-0.999), ceil(xa2-0.999));
    %theta = Gradient(nextgrid(1,1), nextgrid(1,2));
    [xa2, za2, arah, nextgrid, GarisRaypath] = FindNextRaypath2(N, h, xa2, za2, theta, arah, nextgrid, GarisRaypath);
    nextgrid2 = nextgrid(1,1) + (nextgrid(1,2)-1)*N;
    %arah
    %nextgrid
    
    %% Mask Boundary
    % Field Mask
    if nextgrid(1,1) < 1 || nextgrid(1,1) > N
        break
    end
    if nextgrid(1,2) < 1 || nextgrid(1,2) > N
        break
    end
    
    %% Mask in case the ray circulated around the source (Disabled)
    %{
    % ada di batas kanan
    if ffgrid(1,2) == N
    toleransi = GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1),ffgrid(1,2)-h) ...
        + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2));
    end
    % ada di batas bawah
    if ffgrid(1,1) == N
    toleransi = GarisRaypath(ffgrid(1,1),ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1),ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)-h) ...
        + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)+h);
    end
    % ada di batas kiri
    if ffgrid(1,2) == 1 
    toleransi = GarisRaypath(ffgrid(1,1),ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)) ...
        + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)+h);
    end
    % ada di batas atas
    if ffgrid(1,1) == 1
    toleransi = GarisRaypath(ffgrid(1,1),ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1),ffgrid(1,2)+h) ...
        + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1),ffgrid(1,2)-h);
    end
    % Tidak di batas
    if ffgrid(1,2) ~= N && ffgrid(1,1) ~= N && ffgrid(1,2) ~= 1 && ffgrid(1,1) ~= 1
    toleransi = GarisRaypath(ffgrid(1,1),ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)+h) + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)) ...
        + GarisRaypath(ffgrid(1,1)+h,ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1),ffgrid(1,2)-h) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)-h) ...
        + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)) + GarisRaypath(ffgrid(1,1)-h,ffgrid(1,2)+h);
    end
    
    if toleransi >= h
        break
    end
    %}
end

end

