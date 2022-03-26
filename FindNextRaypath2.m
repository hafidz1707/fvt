function [xa2, za2, arah, nextgrid, GarisRaypath] = FindNextRaypath2(N, h, xa, za, theta, arah, nextgrid, GarisRaypath)
zi = nextgrid(1,1);
xi = nextgrid(1,2);
if arah == 1 % Dari Kiri
    alpha2 = atan((zi+h) - za)/h;
    alpha1 = atan((za - zi)/h);
    if theta > (2*pi) - alpha1 || theta < alpha2
        xa2 = xi+h;
        za2 = za + (h * tan(theta));
        arah = 1; % Ke Kanan
        nextgrid = [zi, xi+h];
        
    elseif theta == alpha2
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > alpha2 && theta < pi/2
        xa2 = xa +  (((zi+h) - za) * cot(theta));
        za2 = zi+h;
        arah = 3; % Ke Bawah
        nextgrid = [zi+h, xi];
        
    elseif theta >= pi/2 && theta < pi
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > pi && theta < 1.5*pi
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > 1.5*pi && theta < (2*pi)-alpha1
        xa2 = xa + (zi - za) * cot(theta);
        za2 = zi;
        arah = 7; % Ke Atas
        nextgrid = [zi-h, xi];
        if zi == 1 && arah == 7 %% ill cased
            xa2 = xi+h;
            za2 = zi;
            arah = 5; % Ke Kanan
            nextgrid = [zi, xi+h];
        end
        
    elseif theta == (2*pi)-alpha1
        xa2 = xi+h;
        za2 = zi;
        arah = 7; % Ke Kanan Atas
        nextgrid = [zi-h, xi+h];
    end
    
elseif arah == 2 % Dari Kiri Atas
    if theta > 0 && theta < pi/4
        xa2 = xi+h;
        za2 = za + h*tan(theta);
        arah = 1; % Ke Kanan
        nextgrid = [zi, xi+h];
       
    elseif theta == pi/4
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
       
    elseif theta > pi/4 && theta < pi/2 %pi/2
        xa2 = xa + h*cot(theta);
        za2 = zi+h;
        arah = 3; % Ke Bawah
        nextgrid = [zi+h, xi];
        
    elseif theta >= pi/2 && theta <= 0.75*pi %pi
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > 0.75*pi && theta < 1.15*pi %% Kasus khusus
        xa2 = xi;
        za2 = zi;
        arah = 8; % Dari kanan atas
        nextgrid = [zi, xi-h]; % Ke kiri
       %} 
    elseif theta > 1.15*pi && theta < 1.25*pi %% Kasus khusus
        xa2 = xi;
        za2 = zi;
        arah = 4; % Dari kiri bawah
        nextgrid = [zi-h, xi]; % Ke atas
        
    elseif theta >= 1.25*pi && theta < 2*pi
        xa2 = xi+h;
        za2 = zi;
        arah = 8; % Ke Kanan atas
        nextgrid = [zi-h, xi+h];
    end
    
elseif arah == 3 % Dari Atas
    alpha1 = atan((xa - xi)/h);
    alpha2 = atan(((xi+h) - xa)/h);
    
    if theta > 0 && theta < (pi/2)-alpha2
        xa2 = xi+h;
        za2 = za + (((xi+h) - xa) * tan(theta));
        arah = 1; % Ke Kanan
        nextgrid = [zi, xi+h];
        
    elseif theta == (pi/2)-alpha2
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > (pi/2)-alpha2 && theta < (pi/2)+alpha1
        xa2 = xa + (h*cot(theta));
        za2 = zi+h;
        arah = 3; % Ke Bawah
        nextgrid = [zi+h, xi];
        
    elseif theta == (pi/2)+alpha1
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > (pi/2)+alpha1 && theta < pi
        xa2 = xi;
        za2 = za + (xi-xa)*tan(theta);
        arah = 5; % Ke Kiri 
        nextgrid = [zi, xi-h];
        if xi == 1 && arah == 5 %% ill cased
            xa2 = xi;
            za2 = zi+h;
            arah = 3; % Ke Bawah
            nextgrid = [zi+h, xi];
        end
        
    elseif theta >= pi && theta < 1.5*pi
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > 1.5*pi && theta < 2*pi
        xa2 = xi+h;
        za2 = zi;
        arah = 8; % Ke Kanan Atas
        nextgrid = [zi-h, xi+h];
    end
    
elseif arah == 4 % Dari Kanan Atas
    if theta > 0 && theta < pi/4 % Kasus khusus / ill cased
        xa2 = xi+h;
        za2 = zi;
        arah = 8; % Dari kanan atas
        nextgrid = [zi, xi+h]; % Ke kanan
        
    elseif theta > pi/4 && theta < pi/2
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > pi/2 && theta < 0.75*pi
        xa2 = xa + h*cot(theta);
        za2 = zi+h;
        arah = 3; % Ke Bawah
        nextgrid = [zi+h, xi];
        
    elseif theta == 0.75*pi
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > 0.75*pi && theta < pi
        xa2 = xi;
        za2 = za - h*tan(theta);
        arah = 5; % Ke Kiri
        nextgrid = [zi, xi-h];
        if xi == 1 && arah == 5 %% ill cased
            xa2 = xi;
            za2 = zi+h;
            arah = 3; % Ke Bawah
            nextgrid = [zi+h, xi];
        end
        
    elseif theta >= pi && theta <= 1.5*pi
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > 1.5*pi && theta < 2*pi % Kasus khusus
        xa2 = xi+h;
        za2 = zi;
        arah = 2; % Dari kanan bawah
        nextgrid = [zi-h, xi]; % Ke atas
    end
    
elseif arah == 5 % Dari Kanan
    alpha1 = atan(((zi+h) - za)/h);
    alpha2 = atan((za - zi)/h);
    if theta > 0 && theta <= (pi/2)
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > pi/2 && theta < pi-alpha1
        xa2 = xa + (zi+h - za)*cot(theta);
        za2 = zi+h;
        arah = 3; % Ke Bawah
        nextgrid = [zi+h, xi];
        
    elseif theta == pi-alpha1
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > pi-alpha1 && theta < pi+alpha2
        xa2 = xi;
        za2 = za - h*tan(theta);
        arah = 5; % Ke Kiri
        nextgrid = [zi, xi-h];
        
    elseif theta == pi+alpha2
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > pi+alpha2 && theta < 1.5*pi
        xa2 = xa + (zi-za)*cot(theta);
        za2 = zi;
        arah = 7; % Ke Atas
        nextgrid = [zi-h, xi];
        if zi == 1 && arah == 7 %% ill cased
            xa2 = xi;
            za2 = zi;
            arah = 5; % Ke Kiri
            nextgrid = [zi, xi-h];
        end
        
    elseif theta >= 1.5*pi && theta <= 2*pi
        xa2 = xi+h;
        za2 = zi;
        arah = 8; % Ke Kanan Atas
        nextgrid = [zi-h, xi+h];
        if zi == 1 && arah == 8 %% ill cased
            xa2 = xi+h;
            za2 = zi;
            arah = 5; % Ke Kanan
            nextgrid = [zi, xi+h];
        end
    end
    
elseif arah == 6 % Dari Kanan Bawah
    if theta >= 0 && theta < pi/4 % Kasus khusus
        xa2 = xi+h;
        za2 = zi;
        arah = 4; % Dari kiri bawah
        nextgrid = [zi, xi+h]; % Ke kanan
        
    elseif theta < pi/2 && theta > pi/4 % Kasus khusus
        xa2 = xi+h;
        za2 = zi+h;
        arah = 8; % Dari kanan atas
        nextgrid = [zi+h, xi]; % Ke bawah
        
    elseif theta >= pi/2 && theta <= pi
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > pi && theta < 1.25*pi
        xa2 = xi;
        za2 = za - h*tan(theta);
        arah = 5; % Ke Kiri
        nextgrid = [zi, xi-h];
        if xi == 1 && arah == 5 %% ill cased
            xa2 = xi;
            za2 = zi-h;
            arah = 7; % Ke Atas
            nextgrid = [zi-h, xi];
        end
        
    elseif theta == 1.25*pi
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > 1.25*pi && theta < 1.5*pi
        xa2 = xa - h*cot(theta);
        za2 = zi;
        arah = 7; % Ke Atas
        nextgrid = [zi-h, xi];
        
    elseif theta >= 1.5*pi && theta <= 2*pi
        xa2 = xi+h;
        za2 = zi+h;
        arah = 8; % Ke Kanan Atas
        nextgrid = [zi-h, xi+h];
    end
    
elseif arah == 7 % Dari Bawah
    alpha1 = atan((xa - xi)/h);
    alpha2 = atan(((xi+h) - xa)/h);
    if theta > (1.5*pi)+alpha2 && theta < 2*pi
        xa2 = xi+h;
        za2 = za + (xi+h-xa)*tan(theta);
        arah = 1; % Ke Kanan
        nextgrid = [zi, xi+h];
        
    elseif theta <= pi/2
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > pi/2 && theta <= pi
        xa2 = xi;
        za2 = zi+h;
        arah = 4; % Ke Kiri Bawah
        nextgrid = [zi+h, xi-h];
        
    elseif theta > pi && theta < (1.5*pi)-alpha1
        xa2 = xi;
        za2 = za + (xi-xa)*tan(theta);
        arah = 5; % Ke Kiri
        nextgrid = [zi, xi-h];
        if xi == 1 && arah == 5 %% ill cased
            xa2 = xi;
            za2 = zi-h;
            arah = 7; % Ke Atas
            nextgrid = [zi-h, xi];
        end
        
    elseif theta == (1.5*pi)-alpha1
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > (1.5*pi)-alpha1 && theta < (1.5*pi)+alpha2
        xa2 = xa - h*cot(theta);
        za2 = zi;
        arah = 7; % Ke Atas
        nextgrid = [zi-h, xi];
        
    elseif theta == (1.5*pi)+alpha2
        xa2 = xi+h;
        za2 = zi+h;
        arah = 8; % Ke Kanan Atas
        nextgrid = [zi-h, xi+h];
    end
    
elseif arah == 8 % Dari Kiri Bawah
    if theta >= 1.75*pi && theta <= 2*pi
        xa2 = xi+h;
        za2 = za + h*tan(theta);
        arah = 1; % Ke Kanan
        nextgrid = [zi, xi+h];
        
    elseif theta >= 0 && theta <= 0.5*pi
        xa2 = xi+h;
        za2 = zi+h;
        arah = 2; % Ke Kanan Bawah
        nextgrid = [zi+h, xi+h];
        
    elseif theta > 0.5*pi && theta < 0.75*pi % Kasus khusus
        xa2 = xi;
        za2 = zi+h;
        arah = 6; % Dari kiri atas
        nextgrid = [zi+h, xi]; % Ke bawah
        
    elseif theta > 0.75*pi && theta < pi % Kasus khusus
        xa2 = xi;
        za2 = zi+h;
        arah = 2; % Dari kanan bawah
        nextgrid = [zi, xi-h]; % Ke kiri
        
    elseif theta >= pi && theta <= 1.5*pi
        xa2 = xi;
        za2 = zi;
        arah = 6; % Ke Kiri Atas
        nextgrid = [zi-h, xi-h];
        
    elseif theta > 1.5*pi && theta < 1.75*pi
        xa2 = xa - h*cot(theta);
        za2 = zi;
        arah = 7; % Ke Atas
        nextgrid = [zi-h, xi];
        
    elseif theta == 1.75*pi
        xa2 = xi+h;
        za2 = zi+h;
        arah = 8; % Ke Kanan Atas 
        nextgrid = [zi-h, xi+h];
    end
end
GarisRaypath(zi,xi) = GarisRaypath(zi,xi) + sqrt((xa2-xa)^2 + (za2-za)^2);

if nextgrid(1,1) > N
    nextgrid(1,1) = N;
end
if nextgrid(1,1) < 1
    nextgrid(1,1) = 1;
end
if nextgrid(1,2) > N
    nextgrid(1,2) = N;
end
if nextgrid(1,2) < 1
    nextgrid(1,2) = 1;
end

if GarisRaypath(zi,xi) > sqrt(2)*h
    GarisRaypath(zi,xi) = sqrt(2)*h;
end
end

