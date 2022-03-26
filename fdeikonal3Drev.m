%{
3D Finite Difference Travel Time
%}

function TravelTimesTable = fdeikonal3Drev(N,Nh,h,posisi,t0,Smodel,TravelTimesTable)

%{
Bentuk Matrix : X ke kanan, Y ke bawah, Z matrix 3D nya
contoh penomoran posisi untuk Grid N x N x Nh, untuk N = 5 dan Nh = 2
1   6   11  16  21
2   7   12  17  22
3   8   13  18  23
4   9   14  19  24
5   10  15  20  25

26  31  36  41  46
27  32  37  42  47
28  33  38  43  48
29  34  39  44  49
30  35  40  45  50

Urutan perhitungan travel time 3D adalah :
6 lurus :
1 kanan (x + 1)
2 depan (y + 1)
3 kiri (x - 1)
4 belakang (y - 1)
5 atas (z + 1)
6 bawah (z - 1)

12 Miring :
7 Kanan Belakang (y - 1, x + 1)
8 Kanan Depan (y + 1, x + 1)
9 Kiri Depan (y + 1, x - 1)
10 Kiri Belakang (y - 1, x - 1)
11 belakang bawah (y - 1, z - 1)
12 depan bawah (y + 1, z - 1)
13 depan atas (y + 1, z + 1)
14 belakang atas (y - 1, z + 1)
15 kanan bawah (x + 1, z - 1)
16 kiri bawah (x - 1, z - 1)
17 kiri atas (x - 1, z + 1)
18 kanan atas (x + 1, z + 1)

8 Menyilang :
19 Kanan Belakang Atas (y - 1, x + 1, z + 1)
20 Kanan Depan Atas (y + 1, x + 1, z + 1)
21 Kiri Depan Atas (y + 1, x - 1, z + 1)
22 Kiri Belakang Atas (y - 1, x - 1, z + 1)
23 Kanan Belakang Bawah (y - 1, x + 1, z - 1)
24 Kanan Depan Bawah (y + 1, x + 1, z - 1)
25 Kiri Depan Bawah (y + 1, x - 1, z - 1)
26 Kiri Belakang Bawah (y - 1, x - 1, z - 1)

%}

pos_x = posisi(1); % Posisi grid di X
pos_y = posisi(2); % Posisi grid di Y
pos_z = posisi(3); % Posisi grid di Z

% Dimulai dari Kanan, Depan, Kiri, Belakang, Atas, Bawah
if pos_x ~= N
    Savg_kanan = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x+1,pos_y,pos_z)) / 2;
    traveltime_kanan = t0 + h*Savg_kanan;
    if TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+0) > traveltime_kanan
        TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+0) = traveltime_kanan;
    elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+0) <= traveltime_kanan
        traveltime_kanan = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+0);
    end
end

if pos_y ~= N
    Savg_depan = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z)) / 2;
    traveltime_depan = t0 + h*Savg_depan;
    if TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+0) > traveltime_depan
        TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+0) = traveltime_depan;
    elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+0) <= traveltime_depan
        traveltime_depan = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+0);
    end
end

if pos_x ~= 1
    Savg_kiri = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x-1,pos_y,pos_z)) / 2;
    traveltime_kiri = t0 + h*Savg_kiri;
    if TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+0) > traveltime_kiri
        TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+0) = traveltime_kiri;
    elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+0) <= traveltime_kiri
        traveltime_kiri = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+0);
    end
end

if pos_y ~= 1
    Savg_belakang = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z)) / 2;
    traveltime_belakang = t0 + h*Savg_belakang;
    if TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+0) > traveltime_belakang
        TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+0) = traveltime_belakang;
    elseif TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+0) <= traveltime_belakang
        traveltime_belakang = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+0);
    end
end

if pos_z ~= Nh
    Savg_atas = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z+1)) / 2;
    traveltime_atas = t0 + h*Savg_atas;
    if TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z+1) > traveltime_atas
        TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z+1) = traveltime_atas;
    elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z+1) <= traveltime_atas
        traveltime_atas = TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z+1);
    end
end

if pos_z ~= 1
    Savg_bawah = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z-1)) / 2;
    traveltime_bawah = t0 + h*Savg_bawah;
    if TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z-1) > traveltime_bawah
        TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z-1) = traveltime_bawah;
    elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z-1) <= traveltime_bawah
        traveltime_bawah = TravelTimesTable((pos_x+0) + (N*(pos_y-1)), pos_z-1);
    end
end

% 1/3 Kanan Belakang, Kanan Depan, Kiri Depan, Kiri Belakang
if pos_x < N && pos_y > 1
    Savg_kananbelakang = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x+1,pos_y-1,pos_z)) / 4;
    traveltime_kananbelakang = t0 +  sqrt(2 * (h^2) * (Savg_kananbelakang^2) - ((traveltime_kanan - traveltime_belakang)^2));
    
    if isreal(traveltime_kananbelakang) == 1
        if TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) > traveltime_kananbelakang
            TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) = traveltime_kananbelakang;
        elseif TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) <= traveltime_kananbelakang
            traveltime_kananbelakang = TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0);
        end
    elseif isreal(traveltime_kananbelakang) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_belakang2 = t0 + h*Savg_belakang;
        traveltime_kananbelakang2 = t0 +  sqrt(2 * (h^2) * (Savg_kananbelakang^2) - ((traveltime_kanan2 - traveltime_belakang2)^2));
        if isreal(traveltime_kananbelakang2) == 1
            if TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) > traveltime_kananbelakang2
                TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) = traveltime_kananbelakang2;
                traveltime_kananbelakang = traveltime_kananbelakang2;
            elseif TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0) <= traveltime_kananbelakang2
                traveltime_kananbelakang = TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0);
            end
        elseif isreal(traveltime_kananbelakang2) ~= 1
            traveltime_kananbelakang = TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+0);
        end
    end
end

if pos_x < N && pos_y < N
    Savg_kanandepan = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x+1,pos_y+1,pos_z)) / 4;
    traveltime_kanandepan = t0 +  sqrt(2 * (h^2) * (Savg_kanandepan^2) - ((traveltime_kanan - traveltime_depan)^2));
    
    if isreal(traveltime_kanandepan) == 1
        if TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) > traveltime_kanandepan
            TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) = traveltime_kanandepan;
        elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) <= traveltime_kanandepan
            traveltime_kanandepan = TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0);
        end 
    elseif isreal(traveltime_kanandepan) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_depan2 = t0 + h*Savg_depan;
        traveltime_kanandepan2 = t0 +  sqrt(2 * (h^2) * (Savg_kanandepan^2) - ((traveltime_kanan2 - traveltime_depan2)^2));
        if isreal(traveltime_kanandepan2) == 1
            if TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) > traveltime_kanandepan2
                TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) = traveltime_kanandepan2;
                traveltime_kanandepan = traveltime_kanandepan2;
            elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0) <= traveltime_kanandepan2
                traveltime_kanandepan = TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0);
            end
        elseif isreal(traveltime_kanandepan2) ~= 1
            traveltime_kanandepan = TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+0);
        end
    end
end

if pos_x > 1 && pos_y < N
    Savg_kiridepan = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x-1,pos_y+1,pos_z)) / 4;
    traveltime_kiridepan = t0 +  sqrt(2 * (h^2) * (Savg_kiridepan^2) - ((traveltime_kiri - traveltime_depan)^2));
    
    if isreal(traveltime_kiridepan) == 1
        if TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) > traveltime_kiridepan
            TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) = traveltime_kiridepan;
        elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) <= traveltime_kiridepan
            traveltime_kiridepan = TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0);
        end
    elseif isreal(traveltime_kiridepan) ~= 1
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_depan2 = t0 + h*Savg_depan;
        traveltime_kiridepan2 = t0 +  sqrt(2 * (h^2) * (Savg_kiridepan^2) - ((traveltime_kiri2 - traveltime_depan2)^2));
        if isreal(traveltime_kiridepan2) == 1
            if TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) > traveltime_kiridepan2
                TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) = traveltime_kiridepan2;
                traveltime_kiridepan = traveltime_kiridepan2;
            elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0) <= traveltime_kiridepan2
                traveltime_kiridepan = TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0);
            end
        elseif isreal(traveltime_kiridepan2) ~= 1
            traveltime_kiridepan = TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+0);
        end
    end
end

if pos_x > 1 && pos_y > 1
    Savg_kiribelakang = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x-1,pos_y-1,pos_z)) / 4;
    traveltime_kiribelakang = t0 +  sqrt(2 * (h^2) * (Savg_kiribelakang^2) - ((traveltime_kiri - traveltime_belakang)^2));
    
    if isreal(traveltime_kiribelakang) == 1
        if TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) > traveltime_kiribelakang
            TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) = traveltime_kiribelakang;
        elseif TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) <= traveltime_kiribelakang
            traveltime_kiribelakang = TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0);
        end
    elseif isreal(traveltime_kiribelakang) ~= 1
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_belakang2 = t0 + h*Savg_belakang;
        traveltime_kiribelakang2 = t0 +  sqrt(2 * (h^2) * (Savg_kiribelakang^2) - ((traveltime_kiri2 - traveltime_belakang2)^2));
        if isreal(traveltime_kiribelakang2) == 1
            if TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) > traveltime_kiribelakang2
                TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) = traveltime_kiribelakang2;
                traveltime_kiribelakang = traveltime_kiribelakang2;
            elseif TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0) <= traveltime_kiribelakang2
                traveltime_kiribelakang = TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0);
            end
        elseif isreal(traveltime_kiribelakang2) ~= 1
            traveltime_kiribelakang = TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+0);
        end
    end
end

% 2/3 belakang bawah, depan bawah, depan atas, belakang atas
if pos_y > 1 && pos_z > 1
    Savg_belakangbawah = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + Smodel(pos_x,pos_y-1,pos_z-1)) / 4;
    traveltime_belakangbawah = t0 +  sqrt(2 * (h^2) * (Savg_belakangbawah^2) - ((traveltime_belakang - traveltime_bawah)^2));
    
    if isreal(traveltime_belakangbawah) == 1
        if TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) > traveltime_belakangbawah
            TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) = traveltime_belakangbawah;
        elseif TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) <= traveltime_belakangbawah
            traveltime_belakangbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1);
        end
    elseif isreal(traveltime_belakangbawah) ~= 1
        traveltime_belakang2 = t0 + h*Savg_belakang;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_belakangbawah2 = t0 +  sqrt(2 * (h^2) * (Savg_belakangbawah^2) - ((traveltime_belakang2 - traveltime_bawah2)^2));
        if isreal(traveltime_belakangbawah2) == 1
            if TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) > traveltime_belakangbawah2
                TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) = traveltime_belakangbawah2;
                traveltime_belakangbawah = traveltime_belakangbawah2;
            elseif TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1) <= traveltime_belakangbawah2
                traveltime_belakangbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1);
            end
        elseif isreal(traveltime_belakangbawah2) ~= 1
            traveltime_belakangbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z-1);
        end
    end
end

if pos_y < N && pos_z > 1
    Savg_depanbawah = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + Smodel(pos_x,pos_y+1,pos_z-1)) / 4;
    traveltime_depanbawah = t0 +  sqrt(2 * (h^2) * (Savg_depanbawah^2) - ((traveltime_depan - traveltime_bawah)^2));
    
    if isreal(traveltime_depanbawah) == 1
        if TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) > traveltime_depanbawah
            TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) = traveltime_depanbawah;
        elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) <= traveltime_depanbawah
            traveltime_depanbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1);
        end
    elseif isreal(traveltime_depanbawah) ~= 1
        traveltime_depan2 = t0 + h*Savg_depan;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_depanbawah2 = t0 +  sqrt(2 * (h^2) * (Savg_depanbawah^2) - ((traveltime_depan2 - traveltime_bawah2)^2));
        if isreal(traveltime_depanbawah2) == 1
            if TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) > traveltime_depanbawah2
                TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) = traveltime_depanbawah2;
                traveltime_depanbawah = traveltime_depanbawah2;
            elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1) <= traveltime_depanbawah2
                traveltime_depanbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1);
            end
        elseif isreal(traveltime_depanbawah2) ~= 1
            traveltime_depanbawah = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z-1);
        end
    end
end

if pos_y < N && pos_z < Nh
    Savg_depanatas = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + Smodel(pos_x,pos_y+1,pos_z+1)) / 4;
    traveltime_depanatas = t0 +  sqrt(2 * (h^2) * (Savg_depanatas^2) - ((traveltime_depan - traveltime_atas)^2));
    
    if isreal(traveltime_depanatas) == 1
        if TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) > traveltime_depanatas
            TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) = traveltime_depanatas;
        elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) <= traveltime_depanatas
            traveltime_depanatas = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1);
        end
    elseif isreal(traveltime_depanatas) ~= 1
        traveltime_depan2 = t0 + h*Savg_depan;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_depanatas2 = t0 +  sqrt(2 * (h^2) * (Savg_depanatas^2) - ((traveltime_depan2 - traveltime_atas2)^2));
        if isreal(traveltime_depanatas2) == 1
            if TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) > traveltime_depanatas2
                TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) = traveltime_depanatas2;
                traveltime_depanatas = traveltime_depanatas2;
            elseif TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1) <= traveltime_depanatas2
                traveltime_depanatas = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1);
            end
        elseif isreal(traveltime_depanatas2) ~= 1
            traveltime_depanatas = TravelTimesTable((pos_x+0) + (N*(pos_y-1+1)), pos_z+1);
        end
    end
end

if pos_y > 1 && pos_z < Nh
    Savg_belakangatas = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + Smodel(pos_x,pos_y-1,pos_z+1)) / 4;
    traveltime_belakangatas = t0 +  sqrt(2 * (h^2) * (Savg_belakangatas^2) - ((traveltime_belakang - traveltime_atas)^2));
    
    if isreal(traveltime_belakangatas) == 1
        if TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) > traveltime_belakangatas
            TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) = traveltime_belakangatas;
        elseif TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) <= traveltime_belakangatas
            traveltime_belakangatas = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1);
        end
    elseif isreal(traveltime_belakangatas) ~= 1
        traveltime_belakang2 = t0 + h*Savg_belakang;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_belakangatas2 = t0 +  sqrt(2 * (h^2) * (Savg_belakangatas^2) - ((traveltime_belakang2 - traveltime_atas2)^2));
        if isreal(traveltime_belakangatas) == 1
            if TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) > traveltime_belakangatas2
                TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) = traveltime_belakangatas2;
                traveltime_belakangatas = traveltime_belakangatas2;
            elseif TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1) <= traveltime_belakangatas2
                traveltime_belakangatas = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1);
            end
        elseif isreal(traveltime_belakangatas) ~= 1
            traveltime_belakangatas = TravelTimesTable((pos_x+0) + (N*(pos_y-2)), pos_z+1);
        end
    end
end

% 3/3 kanan bawah, kiri bawah, kiri atas, kanan atas
if pos_x < N && pos_z > 1
    Savg_kananbawah = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + Smodel(pos_x+1,pos_y,pos_z-1)) / 4;
    traveltime_kananbawah = t0 +  sqrt(2 * (h^2) * (Savg_kananbawah^2) - ((traveltime_kanan - traveltime_bawah)^2));
    
    if isreal(traveltime_kananbawah) == 1
        if TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) > traveltime_kananbawah
            TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) = traveltime_kananbawah;
        elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) <= traveltime_kananbawah
            traveltime_kananbawah = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1);
        end
    elseif isreal(traveltime_kananbawah) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_kananbawah2 = t0 +  sqrt(2 * (h^2) * (Savg_kananbawah^2) - ((traveltime_kanan2 - traveltime_bawah2)^2));
        if isreal(traveltime_kananbawah2) == 1
            if TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) > traveltime_kananbawah2
                TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) = traveltime_kananbawah2;
                traveltime_kananbawah = traveltime_kananbawah2;
            elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1) <= traveltime_kananbawah2
                traveltime_kananbawah = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1);
            end
        elseif isreal(traveltime_kananbawah2) ~= 1
            traveltime_kananbawah = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z-1);
        end
    end
end

if pos_x > 1 && pos_z > 1
    Savg_kiribawah = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + Smodel(pos_x-1,pos_y,pos_z-1)) / 4;
    traveltime_kiribawah = t0 +  sqrt(2 * (h^2) * (Savg_kiribawah^2) - ((traveltime_kiri - traveltime_bawah)^2));
    
    if isreal(traveltime_kiribawah) == 1
        if TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) > traveltime_kiribawah
            TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) = traveltime_kiribawah;
        elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) <= traveltime_kiribawah
            traveltime_kiribawah = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1);
        end
    elseif isreal(traveltime_kiribawah) ~= 1
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_bawah2 = t0 + h*Savg_bawah;
        traveltime_kiribawah2 = t0 +  sqrt(2 * (h^2) * (Savg_kiribawah^2) - ((traveltime_kiri2 - traveltime_bawah2)^2));
        if isreal(traveltime_kiribawah2) == 1
            if TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) > traveltime_kiribawah2
                TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) = traveltime_kiribawah2;
                traveltime_kiribawah = traveltime_kiribawah2;
            elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1) <= traveltime_kiribawah2
                traveltime_kiribawah = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1);
            end
        elseif isreal(traveltime_kiribawah2) ~= 1
            traveltime_kiribawah = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z-1);
        end
    end
end

if pos_x > 1 && pos_z < Nh
    Savg_kiriatas = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + Smodel(pos_x-1,pos_y,pos_z+1)) / 4;
    traveltime_kiriatas = t0 +  sqrt(2 * (h^2) * (Savg_kiriatas^2) - ((traveltime_kiri - traveltime_atas)^2));
    
    if isreal(traveltime_kiriatas) == 1
        if TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) > traveltime_kiriatas
            TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) = traveltime_kiriatas;
        elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) <= traveltime_kiriatas
            traveltime_kiriatas = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1);
        end
    elseif isreal(traveltime_kiriatas) ~= 1  
        traveltime_kiri2 = t0 + h*Savg_kiri;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_kiriatas2 = t0 +  sqrt(2 * (h^2) * (Savg_kiriatas^2) - ((traveltime_kiri2 - traveltime_atas2)^2));
        if isreal(traveltime_kiriatas2) == 1
            if TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) > traveltime_kiriatas2
                TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) = traveltime_kiriatas2;
                traveltime_kiriatas = traveltime_kiriatas2;
            elseif TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1) <= traveltime_kiriatas2
                traveltime_kiriatas = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1);
            end
        elseif isreal(traveltime_kiriatas2) ~= 1  
            traveltime_kiriatas = TravelTimesTable((pos_x-1) + (N*(pos_y-1)), pos_z+1);
        end
    end
end

if pos_x < N && pos_z < Nh
    Savg_kananatas = (Smodel(pos_x,pos_y,pos_z) +  Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + Smodel(pos_x+1,pos_y,pos_z+1)) / 4;
    traveltime_kananatas = t0 +  sqrt(2 * (h^2) * (Savg_kananatas^2) - ((traveltime_kanan - traveltime_atas)^2));
    
    if isreal(traveltime_kananatas) == 1
        if TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) > traveltime_kananatas
            TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) = traveltime_kananatas;
        elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) <= traveltime_kananatas
            traveltime_kananatas = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1);
        end
    elseif isreal(traveltime_kananatas) ~= 1
        traveltime_kanan2 = t0 + h*Savg_kanan;
        traveltime_atas2 = t0 + h*Savg_atas;
        traveltime_kananatas2 = t0 +  sqrt(2 * (h^2) * (Savg_kananatas^2) - ((traveltime_kanan2 - traveltime_atas2)^2));
        if isreal(traveltime_kananatas2) == 1
            if TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) > traveltime_kananatas2
                TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) = traveltime_kananatas2;
                traveltime_kananatas = traveltime_kananatas2;
            elseif TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1) <= traveltime_kananatas2
                traveltime_kananatas = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1);
            end
        elseif isreal(traveltime_kananatas2) ~= 1
            traveltime_kananatas = TravelTimesTable((pos_x+1) + (N*(pos_y-1)), pos_z+1);
        end
    end
end

% 1/2 Kanan Belakang Atas, Kanan Depan Atas, Kiri Depan Atas, Kiri Belakang Atas
if pos_x < N && pos_y > 1 && pos_z < Nh
    Savg_kananbelakangatas = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + ...
        Smodel(pos_x+1,pos_y-1,pos_z) + Smodel(pos_x+1,pos_y,pos_z+1) + Smodel(pos_x,pos_y-1,pos_z+1) + Smodel(pos_x+1,pos_y-1,pos_z+1)) / 8;
    traveltime_kananbelakangatas = t0 + (sqrt(6 * (h^2) * (Savg_kananbelakangatas^2) - ((traveltime_kanan - traveltime_belakang)^2) - ((traveltime_kanan - traveltime_atas)^2) - ...
        ((traveltime_belakang - traveltime_atas)^2) - ((traveltime_kananbelakang - traveltime_kananatas)^2) - ((traveltime_kananatas - traveltime_belakangatas)^2) - ...
        ((traveltime_belakangatas - traveltime_kananbelakang)^2)) / sqrt(2));
    if TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+1) > traveltime_kananbelakangatas && isreal(traveltime_kananbelakangatas) == 1
        TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z+1) = traveltime_kananbelakangatas;
    end
end

if pos_x < N && pos_y < N && pos_z < Nh
    Savg_kanandepanatas = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + ...
        Smodel(pos_x+1,pos_y+1,pos_z) + Smodel(pos_x+1,pos_y,pos_z+1) + Smodel(pos_x,pos_y+1,pos_z+1) + Smodel(pos_x+1,pos_y+1,pos_z+1)) / 8;
    traveltime_kanandepanatas = t0 + (sqrt(6 * (h^2) * (Savg_kanandepanatas^2) - ((traveltime_kanan - traveltime_depan)^2) - ((traveltime_kanan - traveltime_atas)^2) - ...
        ((traveltime_depan - traveltime_atas)^2) - ((traveltime_kanandepan - traveltime_kananatas)^2) - ((traveltime_kananatas - traveltime_depanatas)^2) - ...
        ((traveltime_depanatas - traveltime_kanandepan)^2)) / sqrt(2));
    if TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+1) > traveltime_kanandepanatas && isreal(traveltime_kanandepanatas) == 1
        TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z+1) = traveltime_kanandepanatas;
    end
end

if pos_x > 1 && pos_y < N && pos_z < Nh
    Savg_kiridepanatas = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + ...
        Smodel(pos_x-1,pos_y+1,pos_z) + Smodel(pos_x-1,pos_y,pos_z+1) + Smodel(pos_x,pos_y+1,pos_z+1) + Smodel(pos_x-1,pos_y+1,pos_z+1)) / 8;
    traveltime_kiridepanatas = t0 + (sqrt(6 * (h^2) * (Savg_kiridepanatas^2) - ((traveltime_kiri - traveltime_depan)^2) - ((traveltime_kiri - traveltime_atas)^2) - ...
        ((traveltime_depan - traveltime_atas)^2) - ((traveltime_kiridepan - traveltime_kiriatas)^2) - ((traveltime_kiriatas - traveltime_depanatas)^2) - ...
        ((traveltime_depanatas - traveltime_kiridepan)^2)) / sqrt(2));
    if TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+1) > traveltime_kiridepanatas && isreal(traveltime_kiridepanatas) == 1
        TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z+1) = traveltime_kiridepanatas;
    end
end

if pos_x > 1 && pos_y > 1 && pos_z < Nh
    Savg_kiribelakangatas = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z+1) + ...
        Smodel(pos_x-1,pos_y-1,pos_z) + Smodel(pos_x-1,pos_y,pos_z+1) + Smodel(pos_x,pos_y-1,pos_z+1) + Smodel(pos_x-1,pos_y-1,pos_z+1)) / 8;
    traveltime_kiribelakangatas = t0 + (sqrt(6 * (h^2) * (Savg_kiribelakangatas^2) - ((traveltime_kiri - traveltime_belakang)^2) - ((traveltime_kiri - traveltime_atas)^2) - ...
        ((traveltime_belakang - traveltime_atas)^2) - ((traveltime_kiribelakang - traveltime_kiriatas)^2) - ((traveltime_kiriatas - traveltime_belakangatas)^2) - ...
        ((traveltime_belakangatas - traveltime_kiribelakang)^2)) / sqrt(2));
    if TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+1) > traveltime_kiribelakangatas && isreal(traveltime_kiribelakangatas) == 1
        TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z+1) = traveltime_kiribelakangatas;
    end
end

% 2/2 Kanan Belakang Bawah, Kanan Depan Bawah, Kiri Depan Bawah, Kiri Belakang Bawah
if pos_x < N && pos_y > 1 && pos_z > 1
    Savg_kananbelakangbawah = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + ...
        Smodel(pos_x+1,pos_y-1,pos_z) + Smodel(pos_x+1,pos_y,pos_z-1) + Smodel(pos_x,pos_y-1,pos_z-1) + Smodel(pos_x+1,pos_y-1,pos_z-1)) / 8;
    traveltime_kananbelakangbawah = t0 + (sqrt(6 * (h^2) * (Savg_kananbelakangbawah^2) - ((traveltime_kanan - traveltime_belakang)^2) - ((traveltime_kanan - traveltime_bawah)^2) - ...
        ((traveltime_belakang - traveltime_bawah)^2) - ((traveltime_kananbelakang - traveltime_kananbawah)^2) - ((traveltime_kananbawah - traveltime_belakangbawah)^2) - ...
        ((traveltime_belakangbawah - traveltime_kananbelakang)^2)) / sqrt(2));
    if TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z-1) > traveltime_kananbelakangbawah && isreal(traveltime_kananbelakangbawah) == 1
        TravelTimesTable((pos_x+1) + (N*(pos_y-2)), pos_z-1) = traveltime_kananbelakangbawah;
    end
end

if pos_x < N && pos_y < N && pos_z > 1
    Savg_kanandepanbawah = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x+1,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + ...
        Smodel(pos_x+1,pos_y+1,pos_z) + Smodel(pos_x+1,pos_y,pos_z-1) + Smodel(pos_x,pos_y+1,pos_z-1) + Smodel(pos_x+1,pos_y+1,pos_z-1)) / 8;
    traveltime_kanandepanbawah = t0 + (sqrt(6 * (h^2) * (Savg_kanandepanbawah^2) - ((traveltime_kanan - traveltime_depan)^2) - ((traveltime_kanan - traveltime_bawah)^2) - ...
        ((traveltime_depan - traveltime_bawah)^2) - ((traveltime_kanandepan - traveltime_kananbawah)^2) - ((traveltime_kananbawah - traveltime_depanbawah)^2) - ...
        ((traveltime_depanbawah - traveltime_kanandepan)^2)) / sqrt(2));
    if TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z-1) > traveltime_kanandepanbawah && isreal(traveltime_kanandepanbawah) == 1
        TravelTimesTable((pos_x+1) + (N*(pos_y-1+1)), pos_z-1) = traveltime_kanandepanbawah;
    end
end

if pos_x > 1 && pos_y < N && pos_z > 1
    Savg_kiridepanbawah = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y+1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + ...
        Smodel(pos_x-1,pos_y+1,pos_z) + Smodel(pos_x-1,pos_y,pos_z-1) + Smodel(pos_x,pos_y+1,pos_z-1) + Smodel(pos_x-1,pos_y+1,pos_z-1)) / 8;
    traveltime_kiridepanbawah = t0 + (sqrt(6 * (h^2) * (Savg_kiridepanbawah^2) - ((traveltime_kiri - traveltime_depan)^2) - ((traveltime_kiri - traveltime_bawah)^2) - ...
        ((traveltime_depan - traveltime_bawah)^2) - ((traveltime_kiridepan - traveltime_kiribawah)^2) - ((traveltime_kiribawah - traveltime_depanbawah)^2) - ...
        ((traveltime_depanbawah - traveltime_kiridepan)^2)) / sqrt(2));
    if TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z-1) > traveltime_kiridepanbawah && isreal(traveltime_kiridepanbawah) == 1
        TravelTimesTable((pos_x-1) + (N*(pos_y-1+1)), pos_z-1) = traveltime_kiridepanbawah;
    end
end

if pos_x > 1 && pos_y > 1 && pos_z > 1
    Savg_kiribelakangbawah = (Smodel(pos_x,pos_y,pos_z) + Smodel(pos_x-1,pos_y,pos_z) + Smodel(pos_x,pos_y-1,pos_z) + Smodel(pos_x,pos_y,pos_z-1) + ...
        Smodel(pos_x-1,pos_y-1,pos_z) + Smodel(pos_x-1,pos_y,pos_z-1) + Smodel(pos_x,pos_y-1,pos_z-1) + Smodel(pos_x-1,pos_y-1,pos_z-1)) / 8;
    traveltime_kiribelakangbawah = t0 + (sqrt(6 * (h^2) * (Savg_kiribelakangbawah^2) - ((traveltime_kiri - traveltime_belakang)^2) - ((traveltime_kiri - traveltime_bawah)^2) - ...
        ((traveltime_belakang - traveltime_bawah)^2) - ((traveltime_kiribelakang - traveltime_kiribawah)^2) - ((traveltime_kiribawah - traveltime_belakangbawah)^2) - ...
        ((traveltime_belakangbawah - traveltime_kiribelakang)^2)) / sqrt(2));
    if TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z-1) > traveltime_kiribelakangbawah && isreal(traveltime_kiribelakangbawah) == 1
        TravelTimesTable((pos_x-1) + (N*(pos_y-2)), pos_z-1) = traveltime_kiribelakangbawah;
    end
end






