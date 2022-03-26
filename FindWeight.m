%{
Fungsi untuk mencari weighting function (Watanabe, 1999)
%}

function weight = FindWeight(weight,N,b,TravelTime,TravelTimesTable_S2,TravelTimesTable_R2,freq,PasanganSR)
if PasanganSR == b*(b-1)
    for counter = 1:(b*(b-1))
        delta_Time_Table = zeros(N,N);
        for index = 1:N*N
            pos_x = ceil(index/N); % Posisi grid di X
            pos_y = mod(index,N); % Posisi grid di Y
            if pos_y == 0
                pos_y = N;
            end
            delta_Time = TravelTimesTable_S2(pos_x,pos_y,counter) + TravelTimesTable_R2(pos_x,pos_y,counter) - TravelTime(counter,1);
            delta_Time_Table(pos_x,pos_y) = delta_Time;
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x,pos_y,counter) = weighting;
            end
        end
    end
end
if PasanganSR == b
    for counter = 1:b
        delta_Time_Table = zeros(N,N);
        for index = 1:N*N
            pos_x = ceil(index/N); % Posisi grid di X
            pos_y = mod(index,N); % Posisi grid di Y
            if pos_y == 0
                pos_y = N;
            end
            delta_Time = TravelTimesTable_S2(pos_x,pos_y,counter) + TravelTimesTable_R2(pos_x,pos_y,counter) - TravelTime(counter,1);
            delta_Time_Table(pos_x,pos_y) = delta_Time;
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x,pos_y,counter) = weighting;
            end
        end
    end
end
if PasanganSR == b*(b-3)
    for counter = 1:(b*(b-3))
        delta_Time_Table = zeros(N,N);
        for index = 1:N*N
            pos_x = ceil(index/N); % Posisi grid di X
            pos_y = mod(index,N); % Posisi grid di Y
            if pos_y == 0
                pos_y = N;
            end
            delta_Time = TravelTimesTable_S2(pos_x,pos_y,counter) + TravelTimesTable_R2(pos_x,pos_y,counter) - TravelTime(counter,1);
            delta_Time_Table(pos_x,pos_y) = delta_Time;
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x,pos_y,counter) = weighting;
            end
        end
    end
end
if PasanganSR == (b/2)*(b-9)
    for counter = 1:(b/2)*(b-9)
        delta_Time_Table = zeros(N,N);
        for index = 1:N*N
            pos_x = ceil(index/N); % Posisi grid di X
            pos_y = mod(index,N); % Posisi grid di Y
            if pos_y == 0
                pos_y = N;
            end
            delta_Time = TravelTimesTable_S2(pos_x,pos_y,counter) + TravelTimesTable_R2(pos_x,pos_y,counter) - TravelTime(counter,1);
            delta_Time_Table(pos_x,pos_y) = delta_Time;
            weighting = 1 - (2*freq*delta_Time);
            if weighting > 0
                if weighting > 1
                    weighting = 1;
                end
                weight(pos_x,pos_y,counter) = weighting;
            end
        end
    end
end