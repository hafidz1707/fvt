%{
Fungsi untuk cek grid di sekitar transduser untuk menghindari error
%}

function Smodel = checkSR3D(N, Smodel, Source)
for k = 1:size(Source,2)
    pos_x = Source(1,k)+1;
    pos_y = Source(2,k)+1;
    
    % Check atas
    if pos_y > 1
        if Smodel(pos_x,pos_y-1) >= 1/(340*1000)
            Smodel(pos_x,pos_y-1,:) = Smodel(pos_x,pos_y);
        end
    end
    % Check kanan
    if pos_x < N
        if Smodel(pos_x+1,pos_y) >= 1/(340*1000)
            Smodel(pos_x+1,pos_y,:) = Smodel(pos_x,pos_y);
        end
    end
    % Check bawah
    if pos_y < N
        if Smodel(pos_x,pos_y+1) >= 1/(340*1000)
            Smodel(pos_x,pos_y+1,:) = Smodel(pos_x,pos_y);
        end
    end
    % Check kiri
    if pos_x > 1
        if Smodel(pos_x-1,pos_y) >= 1/(340*1000)
            Smodel(pos_x-1,pos_y,:) = Smodel(pos_x,pos_y);
        end
    end
end