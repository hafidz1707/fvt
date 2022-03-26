function Smodel = PilihModel3D(N,Nh,Smodel,opsi)
%{
1 = Model 3D Vertical Layered
2 = Model Diagonal Fracture
3 = Model Lamination
4 = Model Oil-Filled Shear
%}

if opsi == 1
    for h = 1:Nh
        for j = 1:1:N
            for i = (4/10)*(N-1):1:(7/10)*(N-1)
                Smodel(i,j,h) = 1./(1000*3500);
            end
        end
    end

elseif opsi == 2
    
    h = 12;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 13;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 14;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    
    h = 15;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 16;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 17;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    
elseif opsi == 3
    i = 1;
    for j = 1:N
        for h = 1:Nh
            Smodel(j,i,h) = 1./(1000*3000);
            Smodel(j,N-i+1,h) = 1./(1000*3000);
        end
    end
    i = 2;
    for j = 1:N
        for h = 1:Nh
            Smodel(j,i,h) = 1./(1000*3000);
            Smodel(j,N-i+1,h) = 1./(1000*3000);
        end
    end
    i = 3;
    for j = 1:N
        for h = 1:Nh
            Smodel(j,i,h) = 1./(1000*3000);
            Smodel(j,N-i+1,h) = 1./(1000*3000);
        end
    end


elseif opsi == 4
    
    h = 12;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 13;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 14;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    
    h = 15;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 16;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
    h = 17;
    for i = 1:1:N
        for j = 1:1:N
            Smodel(j,i,h) = 1./(1000*1206);
            Smodel(j,i,h+1) = 1./(1000*1206);
            Smodel(j,N-i+1,h) = 1./(1000*1206);
            Smodel(j,N-i+1,h+1) = 1./(1000*1206);
        end
        h = h+1;
    end
end