function [Sinverted, error, c_iterasi, TravelTime] = SIRT_GUI(N,scale,b,Smodel,Sinverted,iterasi,c_iterasi,frekuensi,TravelTime)

% N =  Jumlah Grid
% scale = skala Grid
% b = Jumlah Receiver

rmod = (N-1)/2;
ang = 0:1/b:1-1/b;
r = (N-1)/2;
xsr = r*cos(ang*2*pi)+0.5;
ysr = r*sin(ang*2*pi)+0.5;
Source = [floor(r+ysr);floor(r+xsr)];
Receiver = [floor(r+ysr);floor(r+xsr)];

%%
if c_iterasi == 0
    % Iterasi setiap Source/Receiver Dulu Seharusnya
    TravelTime = zeros(b*(b-1),1);
    counter = 1;
    TravelTimesTable_S2 = zeros(N,N,b*(b-1),1)+100;
    TravelTimesTable_R2 = zeros(N,N,b*(b-1),1)+100;
    for p = 1:b
        for q = 1:b
            if q ~= p
                TravelTimesTable_S = zeros(N,N)+100;
                TravelTimesTable_R = zeros(N,N)+100;

                TravelTimesTable_S(Source(1,p)+1,Source(2,p)+1) = 0;
                posisi_S = [Source(1,p)+1, Source(2,p)+1];

                TravelTimesTable_R(Receiver(1,q)+1,Receiver(2,q)+1) = 0;
                posisi_R = [Source(1,q)+1, Source(2,q)+1];

                FrozenGrid_S = zeros(N,N);
                FrozenGrid_R = zeros(N,N);
                %% Mencari Travel Time
                while sum(FrozenGrid_S(:)) < N*N*200
                    %% Wavefront dari Titik Source
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_S,waktu_S] = FindGlobalMinimum2(TravelTimesTable_S,FrozenGrid_S);
                    FrozenGrid_S(posisi_S(1),posisi_S(2)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesTable_S = fdeikonal2Drev3(N,scale,posisi_S,waktu_S,Smodel,TravelTimesTable_S);

                    %% Wavefront dari Titik Receiver
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_R,waktu_R] = FindGlobalMinimum2(TravelTimesTable_R,FrozenGrid_R);
                    FrozenGrid_R(posisi_R(1),posisi_R(2)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesTable_R = fdeikonal2Drev3(N,scale,posisi_R,waktu_R,Smodel,TravelTimesTable_R);

                end
                disp(['Menghitung Travel Time ', num2str(counter),' dari ', num2str(b*(b-1))])
                TravelTime(counter,1) = TravelTimesTable_S(Receiver(1,q)+1,Receiver(2,q)+1);
                TravelTimesTable_S2(:,:,counter) = TravelTimesTable_S;
                TravelTimesTable_R2(:,:,counter) = TravelTimesTable_R;
                counter = counter + 1;
            end
        end
    end
end

%% Mencari Fungsi Pemberat
%weight = zeros(N,N,(b*(b-1)));
%weight = FindWeight(weight,N,b,TravelTime,TravelTimesTable_S2,TravelTimesTable_R2,frekuensi,size(TravelTime,1));

%% Plot Weighting
%{
Wplot = zeros(N,N);
for count = 4:8:28
    for i = 1:N
        for j = 1:N
            if Wplot(i,j) < weight(i,j,count)
                Wplot(i,j) = weight(i,j,count);
            end
        end
    end
end
Title = strcat('Weight Function Frekuensi 5 MHz');
plottomogram(Title, r+xsr, r+ysr, N, scale, abs(Wplot), 2, 1, r)
%}
%% MSIRT

if c_iterasi == 0
    % Model Awal
    Sinverted = zeros(N,N);
    Sakhir2_5_10_20 = zeros(N,N,4);
    k_inspect = 1;

    Sall = [];
    for i=1:N
        for j=1:N
            if Smodel(j,i) < 1/(341*1000)
                Sall = [Sall Smodel(j,i)];
            end
        end
    end
    sig_E = sum(Sall(:));
    Vavg = 1./(1000*(sig_E/length(Sall)));

    % mengisi velocity model untuk bagian didalam lingkaran
    Sinverted(:,:) = 1/(340*1000);
    rmod = (N-1)/2;
    for i = 1:N
        for j = 1:N
            jarak1 = sqrt(((i-1)-rmod)^2+((j)-1-rmod)^2)-0.5;
            jarak2 = sqrt((i-1-rmod)^2+((j)-1-rmod)^2)-0.5;
            jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
            jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
            if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
                Sinverted(j,i) = 1/(1000*Vavg);
            end    
        end
    end
    Sinverted = recheckSR(N,Sinverted,Source,Vavg);
end
%% ================ proses iterasi ==========================
k = 0; % indeks untuk iterasi
mat_k = []; % matriks untuk menyimpan berapa kali iterasi
mat_error = []; % matriks untuk menyimpan nilai error
mat_errorall = [];
% menghitung error dari model awal
mat_k_time = [];
mat_error_time = [];
time_residual = [];
Stiapiterasi = zeros(N,N,iterasi);

E=[];
Eall = [];
abc = 0;
for i=1:N
    for j=1:N
        if Smodel(j,i) < 1/(341*1000)
            Eall(j,i) = ((Sinverted(j,i)-Smodel(j,i))/Smodel(j,i))^2;
            E(j,i) = Eall(j,i);
            abc = abc + 1;
        end
    end
end
    
sig_E = sum(E(:));
sig_Eall = sum(Eall(:));
delta_Vall = sig_Eall/length(Eall);
error = (sqrt(sig_E/abc))*100;
errorall = sqrt(sum(delta_Vall)/length(delta_Vall))*100;

mat_k = [mat_k k];
mat_error = [mat_error error];
mat_errorall = [mat_errorall errorall];

%while c_iterasi < iterasi
    %% Menghitung Time Kalkulasi
    % Iterasi setiap Source/Receiver Dulu Seharusnya
    disp(['iterasi ke-',num2str(k)]);
    TravelTimeCalc = zeros(b*(b-1),1);
    counter = 1;
    TravelTimesCalc_S2 = zeros(N,N,b*(b-1))+100;
    TravelTimesCalc_R2 = zeros(N,N,b*(b-1))+100;
    for p = 1:b
        for q = 1:b
            if q ~= p
                TravelTimesCalc_S = zeros(N,N)+100;
                TravelTimesCalc_R = zeros(N,N)+100;

                posisi_S = [Source(1,p)+1, Source(2,p)+1];
                TravelTimesCalc_S(Source(1,p) + 1, Source(2,p) + 1) = 0;

                posisi_R = [Source(1,q)+1, Source(2,q)+1];
                TravelTimesCalc_R(Receiver(1,q) + 1, Receiver(2,q) + 1) = 0;

                FrozenGrid_S = zeros(N,N);
                FrozenGrid_R = zeros(N,N);
                %% Mencari Travel Time
                while sum(FrozenGrid_S(:)) < N*N*200
                    %% Wavefront dari Titik Source
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_S,waktu_S] = FindGlobalMinimum2(TravelTimesCalc_S,FrozenGrid_S);
                    FrozenGrid_S(posisi_S(1),posisi_S(2)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesCalc_S = fdeikonal2Drev3(N,scale,posisi_S,waktu_S,Sinverted,TravelTimesCalc_S);
                    % Update Travel Time
                    % Temp.TravelTimesCalc_S = UpdateTravelTimes(N,posisi_S,TravelTimesCalc_S,Temp.TravelTimesUpdate_S);
                    % TravelTimesCalc_S = Temp.TravelTimesCalc_S; % Update Travel Time

                    %% Wavefront dari Titik Receiver
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_R,waktu_R] = FindGlobalMinimum2(TravelTimesCalc_R,FrozenGrid_R);
                    FrozenGrid_R(posisi_R(1),posisi_R(2)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesCalc_R = fdeikonal2Drev3(N,scale,posisi_R,waktu_R,Sinverted,TravelTimesCalc_R);
                    % Update Travel Time
                    % Temp.TravelTimesCalc_R = UpdateTravelTimes(N,posisi_R,TravelTimesCalc_R,Temp.TravelTimesUpdate_R);
                    % TravelTimesCalc_R = Temp.TravelTimesCalc_R; % Update Travel Time

                end
                disp(['Menghitung Travel Time ', num2str(counter),' dari ',num2str(b*(b-1)), ' iterasi ke ',num2str(k)])
                TravelTimeCalc(counter,1) = TravelTimesCalc_S(Receiver(1,q)+1,Receiver(2,q)+1);
                TravelTimesCalc_S2(:,:,counter) = TravelTimesCalc_S;
                TravelTimesCalc_R2(:,:,counter) = TravelTimesCalc_R;
                counter = counter + 1;
            end
        end
    end
    
    %% Mencari Fungsi Pemberat Revisi
    weight_rev = zeros(N,N,b*(b-1));
    weight_rev = FindWeight(weight_rev,N,b,TravelTimeCalc,TravelTimesCalc_S2,TravelTimesCalc_R2,frekuensi,size(TravelTimeCalc,1));
    
    % travel time residual
    delta_Time = TravelTime - TravelTimeCalc;
    
    % perhitungan sigma dari Lij
    delta_S = zeros(N,N);
    for i=1:N
        for j=1:N
            pembilang = 0;
            pembilang2 = 0;
            penyebut = 0;
            total_waktu = b*(b-1);
            for counter = 1:total_waktu
                pembilang = pembilang + (weight_rev(i,j,counter) * delta_Time(counter,1) / TravelTime(counter,1));
                penyebut = penyebut + (weight_rev(i,j,counter));
            end
            if penyebut ~= 0
                delta_S(i,j) = (Sinverted(i,j)*pembilang)/penyebut;
            end
        end
    end
    
    % menyimpan slowness lama, membuat slowness sel setelah iterasi ke k
    Sold = Sinverted;
    Sinverted = Sinverted + delta_S;
    
    % menyimpang nilai slowness di iterasi 2,5,10,dan 20
    if k == 2 || k == 5 || k == 10 || k == 20
        Sakhir2_5_10_20(:,:,k_inspect) = Sinverted;
        k_inspect = k_inspect + 1;
    end
    
    
    % perhitungan nilai error
    % perhitungan sigma((Vnew-Vold)/Vold)
    k = k + 1;
    Stiapiterasi(:,:,k) = Sinverted;
    E=[];
    Eall = [];
    for i=1:N
        for j=1:N
            if Smodel(j,i) < 1/(341*1000)
                E(j,i) = ((Sinverted(j,i)-Smodel(j,i))/Smodel(j,i))^2;
            end
            Eall(j,i) = ((Sinverted(j,i)-Smodel(j,i))/Smodel(j,i))^2;
        end
    end
    
    sig_E = sum(E(:));
    sig_Eall = sum(Eall(:));
    delta_Vall = sig_Eall/length(Eall);
    error = (sqrt(sig_E/abc))*100;
    errorall = sqrt(sum(delta_Vall)/length(delta_Vall))*100;
    
    mat_k = [mat_k k];
    mat_error = [mat_error error];
    mat_errorall = [mat_errorall errorall];
    
    E_time = [];
    E_time_residual = [];
    time_iteration = TravelTimeCalc;
    total_waktu = b*(b-1);
    for i = 1:total_waktu
        E_time = [E_time abs((time_iteration(i) - TravelTime(i)) / TravelTime(i))^2];
        E_time_residual = [E_time_residual (time_iteration(i)-TravelTime(i))^2];
    end
    sig_E_time = sum(E_time/100);
    sig_E_time_residual = sum(E_time_residual);
    divided_E_time_residual = sig_E_time_residual / sum(TravelTime(i));
    
    delta_E_time = sig_E_time/length(time_iteration);
    error_time = sqrt(sum(delta_E_time.^2)/length(delta_E_time))*100;
    mat_k_time = [mat_k_time k];
    mat_error_time = [mat_error_time error_time];
    time_residual = [time_residual divided_E_time_residual];
    
    c_iterasi = c_iterasi + 1;
    %if error <= 1, break
    %end
    pause(0.5);
%end


end

