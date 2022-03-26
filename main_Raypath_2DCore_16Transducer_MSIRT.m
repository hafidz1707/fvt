clear all;
clc;
close all;

N = 101; % Jumlah Grid
% Untuk USG, skalanya adalah mm
scale = 1;
b = 16; % Jumlah Receiver
rotate = 0;
Smodel = zeros(N,N);
Smodel(:,:) = 1/(340*1000); % Kecepatan Udara
rmod = (N-1)/2;
for i = 1:N
    for j = 1:N
        jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
        jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
        if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
            Smodel(j,i) = 1/(2500*1000);
        end    
    end
end

ang = 0:1/b:1-1/b;
r = (N-1)/2;
xsr = r*cos(ang*2*pi)+0.5;
ysr = r*sin(ang*2*pi)+0.5;
Source = [floor(r+ysr);floor(r+xsr)];
Source_ray = [(r+ysr);(r+xsr)];
Receiver = [floor(r+ysr);floor(r+xsr)];

%{
Opsi Model Awal
1 = Model Lapisan Horizontal
2 = Model Lapisan Tipis Horizontal
3 = Model Mineral
4 = Model Tangga
5 = Model Shear Fracture
6 = Model Checkerboard 0.2 x 0.2 mm
7 = Model Checkerboard 1 x 1 mm
8 = Model Checkerboard 2 x 2 mm
9 = Model Checkerboard 3 x 3 mm
10 = Model Checkerboard 4 x 4 mm
11 = Model Checkerboard 5 x 5 mm
%}
opsi = 1;
Smodel = PilihModel(N,Smodel,opsi,b);

for i = 1:N
    for j = 1:N
        jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
        jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
        jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
        if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
        else
            Smodel(j,i) = 1/(340*1000);
        end    
    end
end
Smodel = checkSR(N,Smodel,Source,1000);
if rotate == 1
    Smodel = checkSR(N,Smodel,Source_r,1000);
end

%% Plot Model Awal
Title = strcat('Model Awal');
Vplot = 1./(Smodel*1000);
plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);

% Iterasi setiap Source/Receiver Dulu Seharusnya
TravelTime = zeros(b*(b-1),1);
counter = 1;
TravelTimesTable_S2 = zeros(N,N,b*(b-1),1)+100;
for p = 1:b
    for q = 1:b
        if q ~= p
            TravelTimesTable_S = zeros(N,N)+100;
            
            TravelTimesTable_S(Source(1,p)+1,Source(2,p)+1) = 0;
            posisi_S = [Source(1,p)+1, Source(2,p)+1];
            
            FrozenGrid_S = zeros(N,N);
            %% Mencari Travel Time
            while sum(FrozenGrid_S(:)) < N*N*200
                %% Wavefront dari Titik Source
                % Mencari Dari titik Mana Wave akan di expand
                [posisi_S,waktu_S] = FindGlobalMinimum2(TravelTimesTable_S,FrozenGrid_S);
                FrozenGrid_S(posisi_S(1),posisi_S(2)) = 200; % Marking Titik Tersebut sudah di expand
                
                % Mencari Waktu Tempuh di Sekeliling Titik
                TravelTimesTable_S = fdeikonal2Drev3(N,scale,posisi_S,waktu_S,Smodel,TravelTimesTable_S);
            end
            disp(['Menghitung Travel Time ', num2str(counter),' dari ', num2str(b*(b-1))])
            TravelTime(counter,1) = TravelTimesTable_S(Receiver(1,q)+1,Receiver(2,q)+1);
            TravelTimesTable_S2(:,:,counter) = TravelTimesTable_S;
            counter = counter + 1;
        end
    end
end

%% MSIRT
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
            Sinverted(j,i) = 1/(Vavg*1000);
        end    
    end
end
Sinverted = recheckSR(N,Sinverted,Source,Vavg);
if rotate == 1
    Sinverted = recheckSR(N,Sinverted,Source_r,Vavg);
end

%% Plot Model Awal Iterasi
Title = strcat('Model Awal Iterasi');
Vplot = 1./(Sinverted*1000);
plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);
%% ================ proses iterasi ==========================
k = 0; % indeks untuk iterasi
mat_k = []; % matriks untuk menyimpan berapa kali iterasi
mat_error = []; % matriks untuk menyimpan nilai error
mat_errorall = [];
% menghitung error dari model awal
mat_k_time = [];
mat_error_time = [];
time_residual = [];
iterasi = 20;
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

while k < iterasi
    %% Menghitung Time Kalkulasi
    % Iterasi setiap Source/Receiver Dulu Seharusnya
    disp(['iterasi ke-',num2str(k)]);
    TravelTimeCalc = zeros(b*(b-1),1);
    counter = 1;
    TravelTimesCalc_S2 = zeros(N,N,b*(b-1))+100;
    GradientTravelTime = zeros(N,N,b*(b-1));
    Lij = [];
    Lj = [];
    for p = 1:b
        for q = 1:b
            if q ~= p
                TravelTimesCalc_S = zeros(N,N)+100;
                
                posisi_S_ray = [Source_ray(1,p)+1, Source_ray(2,p)+1];
                posisi_R_ray = [Source_ray(1,q)+1, Source_ray(2,q)+1];
                
                posisi_S = [Source(1,p)+1, Source(2,p)+1];
                TravelTimesCalc_S(Source(1,p) + 1, Source(2,p) + 1) = 0;
                
                FrozenGrid_S = zeros(N,N);
                %% Mencari Travel Time
                while sum(FrozenGrid_S(:)) < N*N*200
                    %% Wavefront dari Titik Receiver
                    [posisi_S,waktu_S] = FindGlobalMinimum2(TravelTimesCalc_S,FrozenGrid_S);
                    FrozenGrid_S(posisi_S(1),posisi_S(2)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesCalc_S = fdeikonal2Drev3(N,scale,posisi_S,waktu_S,Sinverted,TravelTimesCalc_S);
                end
                disp(['Menghitung Travel Time ', num2str(counter),' dari ',num2str(b*(b-1)), ' iterasi ke ',num2str(k)])
                TravelTimeCalc(counter,1) = TravelTimesCalc_S(Receiver(1,q)+1,Receiver(2,q)+1);
                TravelTimesCalc_S2(:,:,counter) = TravelTimesCalc_S;
                
                GradientTravelTime(:,:,counter) = SteepestDescent(N,scale,TravelTimesCalc_S2(:,:,counter));
                Lij(:,:,counter) = FindRaypath(N,scale,posisi_S_ray,posisi_R_ray,GradientTravelTime(:,:,counter));
                sumray = Lij(:,:,counter);
                Lj(counter) = sum(sumray(:));
                %Lasli(counter) = sqrt( (posisi_R_ray(1,1) - posisi_S_ray(1,1))^2 + (posisi_R_ray(1,2)-posisi_S_ray(1,2))^2);
                %GarisRaypath = zeros(N,N);
                %GarisRaypath = FindRaypath(N,h,Posisi_S_ray,Posisi_R_ray,GradientTravelTime,GarisRaypath);
                counter = counter + 1;
            end
        end
    end
    
    % travel time residual
    delta_Time = TravelTime - TravelTimeCalc;
    
    % travel time residual yang didistibusikan ke setiap sel
    delta_Tij = zeros(N,N,b*(b-1));
    for sinar = 1:b*(b-1)
        for i = 1:N
            for j = 1:N
                delta_Tij(j,i,sinar) = ( Lij(j,i,sinar) * Sinverted(j,i) * delta_Time(sinar,1) ) / TravelTimeCalc(sinar,1);
            end
        end
    end
    
    % faktor koreksi slowness tiap sel
    % perhitungan sigma dari delta_Tij
    Sigma_delta_Tij = zeros(N,N);
    for i = 1:N
        for j = 1:N
            for sinar = 1:b*(b-1)
                Sigma_delta_Tij(j,i) = Sigma_delta_Tij(j,i) + delta_Tij(j,i,sinar); 
            end
        end
    end
    
    % perhitungan sigma dari Lij di setiap sel
    Sigma_Lij = zeros(N,N);
    for i = 1:N
        for j = 1:N
            for sinar = 1:b*(b-1)
                Sigma_Lij(j,i) = Sigma_Lij(j,i) + Lij(j,i,sinar);
            end
        end
    end
    
    % Perhitungan koreksi slowness
    delta_Si = zeros(N,N);
    for i = 1:N
        for j = 1:N
            if Sigma_Lij(j,i) ~= 0
                delta_Si(j,i) = Sigma_delta_Tij(j,i) / Sigma_Lij(j,i);
            end
        end
    end
    
    % menyimpan slowness lama, membuat slowness sel setelah iterasi ke k
    Sold = Sinverted;
    for i = 1:N
        for j = 1:N
            if Smodel(j,i) < 1/(341*1000)
                Sinverted(j,i) = Sinverted(j,i) + delta_Si(j,i);
            end
        end
    end
    %Sinverted = Sinverted + delta_Si;
    
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
    if error <= 0.0001, break
    end
    pause(5)
end

Title = strcat('Model Akhir MSIRT');
Vplot = 1./(1000*Sinverted);
plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);


mat_error_rel = [];
Erel = [];
for n = 1:50
    for i=1:N
        for j=1:N
            if Smodel(j,i) < 1/(341*1000)
                Erel(j,i) = abs(((Stiapiterasi(j,i,n)-Sinverted(j,i))/Stiapiterasi(j,i,n)));
            end
        end
    end
    sig_Erel = sum(Erel(:));
    error_rel = (sig_Erel/abc)*100;
    mat_error_rel = [mat_error_rel error_rel];
    Sinverted(:,:) = Stiapiterasi(:,:,n);
end

%% Plot Error Time RMS
figure
plot(mat_k_time, mat_error_time)
title('Error Time RMS vs iterasi ke-n MSIRT')
xlabel('iterasi ke-n')
ylabel('Error Time RMS (%)')

%% Plot Travel Time Residual
figure
plot(mat_k_time, time_residual)
title('Time Residual vs iterasi ke-n MSIRT')
xlabel('iterasi ke-n')
ylabel('Time Residual (Fraction)')

%% Plot Error V RMS all
figure
plot(mat_k, mat_errorall)
title('Error RMS vs iterasi ke-n MSIRT')
xlabel('iterasi ke-n')
ylabel('Error Velocity RMS (%)')

%% Plot Error V relatif
figure
plot(mat_k_time, mat_error_rel)
title('Error Velocity Relatif vs iterasi ke-n MSIRT')
xlabel('iterasi ke-n')
ylabel('Error Velocity Relatif (%)')

%% Plot Error V RMS
figure
plot(mat_k, mat_error)
title('Error Vrms absolut vs iterasi ke-n MSIRT')
xlabel('iterasi ke-n')
ylabel('Error Vrms (%)')
%% Plot Model Akhir
Title = strcat('Model Akhir MSIRT');
Vplot = 1./(1000*Sinverted);
plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);
%Epsilon = AnisoArrowRev(N,Vplot);

%% Gif
filename = 'Raypath_CKB5mm_56_50iterasi.gif';
for n = 0:1:50
    if n == 0
        Title = strcat('Model MSIRT Iterasi ke - ',num2str(n),' Error : ',num2str(mat_error(n+1)),' %');
        figur = figure('Name', Title, 'color', 'white','NumberTitle','off');
        Vplot = 1./(1000*Sinverted(:,:));
        plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);
        title(Title);

        frame = getframe(figur); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        pause(0.5);
    else
        Title = strcat('Model MSIRT Iterasi ke - ',num2str(n),' Error : ',num2str(mat_error(n+1)),' %');
        figur = figure('Name', Title, 'color', 'white','NumberTitle','off');
        Vplot = 1./(1000*Stiapiterasi(:,:,n));
        plottomogram(Title, r+xsr, r+ysr, N, scale, Vplot, 1, 1, r);
        title(Title);

        frame = getframe(figur); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        pause(0.5);
    end
    close all;
end