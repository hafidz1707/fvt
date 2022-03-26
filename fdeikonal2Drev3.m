%{
2D Finite Difference Travel Time
%}

function TravelTimesTable = fdeikonal2Drev3(N,h,posisi,t0,Smodel,TravelTimesTable)

%{
Bentuk Matrix : X ke kanan, Y ke bawah
contoh penomoran posisi untuk Grid N x N, untuk N = 5
1   6   11  16  21
2   7   12  17  22
3   8   13  18  23
4   9   14  19  24
5   10  15  20  25

Urutan perhitungan travel time dari angka 12 berputar searah jarum jam
X0X XXX XXX XXX XX0 XXX XXX 0XX
XXX XX0 XXX 0XX XXX XXX XXX XXX
XXX XXX X0X XXX XXX XX0 0XX XXX
%}

pos_x = posisi(1); % Posisi grid di X
pos_y = posisi(2); % Posisi grid di Y

%Dimulai dari Atas, Kanan, Bawah, Kiri
if pos_y ~= 1
    Savg_atas = (Smodel(pos_x,pos_y) + Smodel(pos_x,pos_y-1)) / 2;
    traveltime_atas = t0 + h*Savg_atas;
    if TravelTimesTable(pos_x,pos_y-1) > traveltime_atas
        TravelTimesTable(pos_x,pos_y-1) = traveltime_atas;
    elseif TravelTimesTable(pos_x,pos_y-1) <= traveltime_atas
        traveltime_atas = TravelTimesTable(pos_x,pos_y-1);
    end
end
if pos_x ~= N
    Savg_kanan = (Smodel(pos_x,pos_y) + Smodel(pos_x+1,pos_y)) / 2;
    traveltime_kanan = t0 + h*Savg_kanan;
    if TravelTimesTable(pos_x+1,pos_y) > traveltime_kanan
        TravelTimesTable(pos_x+1,pos_y) = traveltime_kanan;
    elseif TravelTimesTable(pos_x+1,pos_y) <= traveltime_kanan
        traveltime_kanan = TravelTimesTable(pos_x+1,pos_y);
    end
end
if pos_y ~= N
    Savg_bawah = (Smodel(pos_x,pos_y) + Smodel(pos_x,pos_y+1)) / 2;
    traveltime_bawah = t0 + h*Savg_bawah;
    if TravelTimesTable(pos_x,pos_y+1) > traveltime_bawah
        TravelTimesTable(pos_x,pos_y+1) = traveltime_bawah;
    elseif TravelTimesTable(pos_x,pos_y+1) <= traveltime_bawah
        traveltime_bawah = TravelTimesTable(pos_x,pos_y+1);
    end
end
if pos_x ~= 1
    Savg_kiri = (Smodel(pos_x,pos_y) + Smodel(pos_x-1,pos_y)) / 2;
    traveltime_kiri = t0 + h*Savg_kiri;
    if TravelTimesTable(pos_x-1,pos_y) > traveltime_kiri
        TravelTimesTable(pos_x-1,pos_y) = traveltime_kiri;
    elseif TravelTimesTable(pos_x-1,pos_y) <= traveltime_kiri
        traveltime_kiri = TravelTimesTable(pos_x-1,pos_y);
    end
end

%Dimulai dari KananAtas, KananBawah, KiriBawah, KiriAtas
if pos_x < N && pos_y > 1
    Savg_kananatas = (Smodel(pos_x,pos_y) +  Smodel(pos_x+1,pos_y) + Smodel(pos_x,pos_y-1) + Smodel(pos_x+1,pos_y-1)) / 4;
    traveltime_kananatas = (t0 +  sqrt(2 * (h^2) * (Savg_kananatas^2) - ((traveltime_kanan - traveltime_atas)^2)));
    if TravelTimesTable(pos_x+1,pos_y-1) > traveltime_kananatas && isreal(traveltime_kananatas) == 1
        TravelTimesTable(pos_x+1,pos_y-1) = traveltime_kananatas;
    % Case if unreal
    elseif isreal(traveltime_kananatas) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_kananatas2 = (t0 +  sqrt(2 * (h^2) * (Savg_kananatas^2) - ((traveltime_kanan2 - traveltime_atas2)^2)));
        if TravelTimesTable(pos_x+1,pos_y-1) > traveltime_kananatas2 && isreal(traveltime_kananatas2) == 1
            TravelTimesTable(pos_x+1,pos_y-1) = traveltime_kananatas2;
        end
    end  
end

if pos_x < N && pos_y < N
    Savg_kananbawah = (Smodel(pos_x,pos_y) +  Smodel(pos_x+1,pos_y) + Smodel(pos_x,pos_y+1) + Smodel(pos_x+1,pos_y+1)) / 4;
    traveltime_kananbawah = (t0 +  sqrt(2 * (h^2) * (Savg_kananbawah^2) - ((traveltime_kanan - traveltime_bawah)^2)));
    if TravelTimesTable(pos_x+1,pos_y+1) > traveltime_kananbawah && isreal(traveltime_kananbawah) == 1
        TravelTimesTable(pos_x+1,pos_y+1) = traveltime_kananbawah;
    % Case if unreal
    elseif isreal(traveltime_kananbawah) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_kananbawah2 = (t0 +  sqrt(2 * (h^2) * (Savg_kananbawah^2) - ((traveltime_kanan2 - traveltime_bawah2)^2)));
        if TravelTimesTable(pos_x+1,pos_y+1) > traveltime_kananbawah2 && isreal(traveltime_kananbawah2) == 1
            TravelTimesTable(pos_x+1,pos_y+1) = traveltime_kananbawah2;
        end
    end
end
if pos_x > 1 && pos_y < N
    Savg_kiribawah = (Smodel(pos_x,pos_y) +  Smodel(pos_x,pos_y+1) + Smodel(pos_x-1,pos_y) + Smodel(pos_x-1,pos_y+1)) / 4;
    traveltime_kiribawah = (t0 +  sqrt(2 * (h^2) * (Savg_kiribawah^2) - ((traveltime_kiri - traveltime_bawah)^2)));
    if TravelTimesTable(pos_x-1,pos_y+1) > traveltime_kiribawah && isreal(traveltime_kiribawah) == 1
        TravelTimesTable(pos_x-1,pos_y+1) = traveltime_kiribawah;
    % Case if unreal
    elseif isreal(traveltime_kiribawah) ~= 1
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_kiribawah2 = (t0 +  sqrt(2 * (h^2) * (Savg_kiribawah^2) - ((traveltime_kiri2 - traveltime_bawah2)^2)));
        if TravelTimesTable(pos_x-1,pos_y+1) > traveltime_kiribawah2 && isreal(traveltime_kiribawah2) == 1
            TravelTimesTable(pos_x-1,pos_y+1) = traveltime_kiribawah2;
        end
    end
end
if pos_x > 1 && pos_y > 1
    Savg_kiriatas = (Smodel(pos_x,pos_y) +  Smodel(pos_x,pos_y-1) + Smodel(pos_x-1,pos_y) + Smodel(pos_x-1,pos_y-1)) / 4;
    traveltime_kiriatas = (t0 +  sqrt(2 * (h^2) * (Savg_kiriatas^2) - ((traveltime_kiri - traveltime_atas)^2)));
    if TravelTimesTable(pos_x-1,pos_y-1) > traveltime_kiriatas && isreal(traveltime_kiriatas) == 1
        TravelTimesTable(pos_x-1,pos_y-1) = traveltime_kiriatas;
    % Case if unreal
    elseif isreal(traveltime_kiriatas) ~= 1
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_kiriatas2 = (t0 +  sqrt(2 * (h^2) * (Savg_kiriatas^2) - ((traveltime_kiri2 - traveltime_atas2)^2)));
        if TravelTimesTable(pos_x-1,pos_y-1) > traveltime_kiriatas2 && isreal(traveltime_kiriatas2) == 1
            TravelTimesTable(pos_x-1,pos_y-1) = traveltime_kiriatas2;
        end
    end
end