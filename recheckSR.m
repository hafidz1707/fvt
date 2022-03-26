function Smodel = recheckSR(N, Smodel, Source, Vel)
for k = 1:size(Source,2)
    pos_x = Source(2,k)+1;
    pos_y = Source(1,k)+1;
    % Check atas
    if pos_y > 1
        if Smodel(pos_y-1,pos_x) >= 1/(340*1000)
            Smodel(pos_y-1,pos_x) = Smodel(pos_y,pos_x);
        end
    end
    % Check kanan
    if pos_x < N
        if Smodel(pos_y,pos_x+1) >= 1/(340*1000)
            Smodel(pos_y,pos_x+1) = Smodel(pos_y,pos_x);
        end
    end
    % Check bawah
    if pos_y < N
        if Smodel(pos_y+1,pos_x) >= 1/(340*1000)
            Smodel(pos_y+1,pos_x) = Smodel(pos_y,pos_x);
        end
    end
    % Check kiri
    if pos_x > 1
        if Smodel(pos_y,pos_x-1) >= 1/(340*1000)
            Smodel(pos_y,pos_x-1) = Smodel(pos_y,pos_x);
        end
    end
end