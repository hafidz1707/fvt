%{
Fungsi untuk mencari weighting function (Watanabe, 1999)
%}

function weight = FindWeight3D(weight,N,Nh,b,TravelTime,TravelTimesTable_S2,TravelTimesTable_R2,freq,PasanganSR)
if PasanganSR == (b*3)*(b*3-1)
    for counter = 1:(b*3)*(b*3-1)
        for index = 1:N*N*Nh
            pos_z = ceil(index/(N*N)); % Posisi grid di Z
            pos_y = ceil((mod(index,N*N))/N);
            pos_x = mod((mod(index,N*N)),N); % Posisi grid di Y
            if pos_x == 0
                pos_x = N;
            end
            if pos_y == 0
                pos_y = N;
            end

            delta_Time = TravelTimesTable_S2(pos_x + (N*(pos_y-1)),pos_z,counter) + TravelTimesTable_R2(pos_x + (N*(pos_y-1)),pos_z,counter) - TravelTime(counter,1);
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x + (N*(pos_y-1)),pos_z,counter) = weighting;
            end
        end
    end
elseif PasanganSR == (b*5)*(b*5-1)
    for counter = 1:(b*5)*(b*5-1)
        for index = 1:N*N*Nh
            pos_z = ceil(index/(N*N)); % Posisi grid di Z
            pos_y = ceil((mod(index,N*N))/N);
            pos_x = mod((mod(index,N*N)),N); % Posisi grid di Y
            if pos_x == 0
                pos_x = N;
            end
            if pos_y == 0
                pos_y = N;
            end

            delta_Time = TravelTimesTable_S2(pos_x + (N*(pos_y-1)),pos_z,counter) + TravelTimesTable_R2(pos_x + (N*(pos_y-1)),pos_z,counter) - TravelTime(counter,1);
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x + (N*(pos_y-1)),pos_z,counter) = weighting;
            end
        end
    end
end