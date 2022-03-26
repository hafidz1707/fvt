clear all;
clc;
close all;

tic;
N = 21; % Sum of Grid
Nh = 51; % Sum of Vertical Grid
scale = 1;
b = 8; % Sum of Receiver
rotate = 0; % 0 = not rotated, 1 = rotated
freq = 1000000; % Frequency in Hz

%% Creating Base Model

Smodel = zeros(N,N,Nh);
Smodel(:,:,:) = 1/(340*1000); % Velocity of air
rmod = (N-1)/2;
for k = 1:Nh
    for i = 1:N
        for j = 1:N
            jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
            jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
            if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
                Smodel(j,i,k) = 1/(2000*1000);
            end    
        end
    end
end

ang = 0:1/b:1-1/b;
r = (N-1)/2;
xsr = []; ysr = []; zsr = [];

for i = 1:(Nh-1)/4:Nh
    xsr = cat(2, xsr, r*cos(ang*2*pi)+0.5);
    ysr = cat(2, ysr, r*sin(ang*2*pi)+0.5);
    for j = 1:b
        zsr = cat(1, zsr, floor(i));
    end
end

zsr = zsr';
% Saving the source and receiver coordinate
Source = [floor(r+xsr); floor(r+ysr); zsr];
Receiver = [floor(r+xsr); floor(r+ysr); zsr];

%% Forward Modelling
%{
First Model Option
1 = Model 3D Vertical Layered
2 = Model Diagonal Fracture
3 = Model Lamination
4 = Model Oil-Filled Shear
%}
opsi = 4;
Smodel = PilihModel3D(N,Nh,Smodel,opsi);

for k = 1:Nh
    for i = 1:N
        for j = 1:N
            jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
            jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
            if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
            else
                Smodel(j,i,k) = 1/(340*1000);
            end    
        end
    end
end
Smodel = checkSR3D(N,Smodel,Source);

% Plot First Model
xx = zeros(N,N,Nh);
yy = zeros(N,N,Nh);
zz = zeros(N,N,Nh);
for h = 1 : 1 : Nh+1
    for j = 1 : 1 : N+1
        for i = 1 : 1 : N+1
            xx(i,j,h) = j-1;
            yy(i,j,h) = i-1;
            zz(i,j,h) = h-1;
        end
    end
end

figure;
Title = strcat('Model Awal');
Slice3D_Model(Title,xx,yy,zz,Smodel,N,Nh);

figure;
Title = strcat('Model Awal');
Silinder3D_Model(Title,N,Nh,Smodel)

figure;
Title = strcat('Model Awal');
Silinder3D_Model_custom(Title,N,Nh,Smodel,custom123)

%% Finite-Difference Travel Time
% Iterasi setiap Source/Receiver Dulu Seharusnya
TravelTime = zeros((b*5)*(b*5-1),1);
counter = 1;
TravelTimesTable_S2 = zeros(N*N,Nh,(b*5)*(b*5-1),1)+100;
TravelTimesTable_R2 = zeros(N*N,Nh,(b*5)*(b*5-1),1)+100;
for p = 1:b*5
    for q = 1:b*5
        if q ~= p
            TravelTimesTable_S = zeros(N*N,Nh)+100;
            TravelTimesTable_R = zeros(N*N,Nh)+100;

            TravelTimesTable_S((Source(1,p)+1) + (N*(Source(2,p))), Source(3,p)) = 0;
            posisi_S = [Source(1,p)+1, Source(2,p)+1, Source(3,p)];

            TravelTimesTable_R((Receiver(1,q)+1) + (N*(Receiver(2,q))), Receiver(3,q)) = 0;
            posisi_R = [Receiver(1,q)+1, Receiver(2,q)+1, Receiver(3,q)];

            FrozenGrid_S = zeros(N*N,Nh);
            FrozenGrid_R = zeros(N*N,Nh);
            %% Mencari Travel Time
            while sum(FrozenGrid_S(:)) < N*N*Nh*200
                %% Wavefront dari Titik Source
                % Mencari Dari titik Mana Wave akan di expand
                [posisi_S,waktu_S] = FindGlobalMinimum3D(N,TravelTimesTable_S,FrozenGrid_S);
                FrozenGrid_S(posisi_S(1) + (N*(posisi_S(2)-1)), posisi_S(3)) = 200; % Marking Titik Tersebut sudah di expand

                % Mencari Waktu Tempuh di Sekeliling Titik
                TravelTimesTable_S = fdeikonal3Drev(N,Nh,scale,posisi_S,waktu_S,Smodel,TravelTimesTable_S);

                %% Wavefront dari Titik Receiver
                % Mencari Dari titik Mana Wave akan di expand
                [posisi_R,waktu_R] = FindGlobalMinimum3D(N,TravelTimesTable_R,FrozenGrid_R);
                FrozenGrid_R(posisi_R(1) + (N*(posisi_R(2)-1)), posisi_R(3)) = 200; % Marking Titik Tersebut sudah di expand

                % Mencari Waktu Tempuh di Sekeliling Titik
                TravelTimesTable_R = fdeikonal3Drev(N,Nh,scale,posisi_R,waktu_R,Smodel,TravelTimesTable_R);
            end
            disp(['Menghitung Travel Time ', num2str(counter),' dari ', num2str((b*5)*(b*5-1))])
            TravelTime(counter,1) = TravelTimesTable_S((Receiver(1,q)+1) + (N*(Receiver(2,q))), Receiver(3,q));
            TravelTimesTable_S2(:,:,counter) = TravelTimesTable_S;
            TravelTimesTable_R2(:,:,counter) = TravelTimesTable_R;
            counter = counter + 1;
        end
    end
end

%% Weighting Function
weight = zeros(N*N,Nh,(b*5)*(b*5-1),1);
weight = FindWeight3D(weight,N,Nh,b,TravelTime,TravelTimesTable_S2,TravelTimesTable_R2,freq,size(TravelTime,1));

%% Plot Weighting (Disabled)
%{
Wplot = zeros(N,N);
for count = 3:3
    for i = 1:N
        for j = 1:N
            if Wplot(i,j) < weight(i,j,count)
                Wplot(i,j) = weight(i,j,count);
            end
        end
    end
end
Title = strcat('Weight Function Frekuensi 1 MHz');
plottomogram(Title, r+xsr, r+ysr, N, scale, abs(Wplot), 2, 1, r)
%}

%% MSIRT Algorithm
Sall = [];
for k = 1:Nh
    for i=1:N
        for j=1:N
            if Smodel(j,i,k) < 1/(341*1000)
                Sall = [Sall Smodel(j,i,k)];
            end
        end
    end
end
sig_E = sum(Sall(:));
Vavg = 1./(1000*(sig_E/length(Sall)));

% Model Awal
Sinverted = zeros(N,N,Nh);
Sakhir2_5_10_20 = zeros(N,N,Nh,4);
k_inspect = 1;
% mengisi velocity model untuk bagian didalam lingkaran
Sinverted(:,:,:) = 1/(340*1000);
rmod = (N-1)/2;
for k = 1:Nh
    for i = 1:N
        for j = 1:N
            jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
            jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
            jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
            if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
                Sinverted(j,i,k) = 1/(1000*Vavg);
            end    
        end
    end
end
Sinverted = checkSR3D(N,Sinverted,Source);


%% ================ iteration ==========================
k = 0;
mat_k = []; % matriks untuk menyimpan berapa kali iterasi
mat_error = []; % matriks untuk menyimpan nilai error
mat_errorall = [];
% menghitung error dari model awal
mat_k_time = [];
mat_error_time = [];
time_residual = [];
iterasi = 20;
Stiapiterasi = zeros(N,N,Nh,iterasi);
stopwatch = [];

E=[];
Eall = [];
abc = 0;
for h = 1:Nh
    for j=1:N
        for i=1:N
            if Smodel(i,j,h) < 1/(341*1000)
                Eall(i,j,h) = ((Sinverted(i,j,h)-Smodel(i,j,h))/Smodel(i,j,h))^2;
                E(i,j,h) = Eall(i,j,h);
                abc = abc + 1;
            end
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
    TravelTimeCalc = zeros((b*5)*(b*5-1),1);
    counter = 1;
    TravelTimesCalc_S2 = zeros(N*N,Nh,(b*5)*(b*5-1),1)+100;
    TravelTimesCalc_R2 = zeros(N*N,Nh,(b*5)*(b*5-1),1)+100;
    for p = 1:b*5
        for q = 1:b*5
            if q ~= p
                
                TravelTimesCalc_S = zeros(N*N,Nh)+100;
                TravelTimesCalc_R = zeros(N*N,Nh)+100;
                
                
                TravelTimesCalc_S((Source(1,p)+1) + (N*(Source(2,p))), Source(3,p)) = 0;
                posisi_S = [Source(1,p)+1, Source(2,p)+1, Source(3,p)];

                
                TravelTimesCalc_R((Receiver(1,q)+1) + (N*(Receiver(2,q))), Receiver(3,q)) = 0;
                posisi_R = [Receiver(1,q)+1, Receiver(2,q)+1, Receiver(3,q)];

                FrozenGrid_S = zeros(N*N,Nh);
                FrozenGrid_R = zeros(N*N,Nh);
                %% Mencari Travel Time
                while sum(FrozenGrid_S(:)) < N*N*Nh*200
                    %% Wavefront dari Titik Source
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_S,waktu_S] = FindGlobalMinimum3D(N,TravelTimesCalc_S,FrozenGrid_S);
                    FrozenGrid_S(posisi_S(1) + (N*(posisi_S(2)-1)), posisi_S(3)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesCalc_S = fdeikonal3Drev(N,Nh,scale,posisi_S,waktu_S,Sinverted,TravelTimesCalc_S);

                    %% Wavefront dari Titik Receiver
                    % Mencari Dari titik Mana Wave akan di expand
                    [posisi_R,waktu_R] = FindGlobalMinimum3D(N,TravelTimesCalc_R,FrozenGrid_R);
                    FrozenGrid_R(posisi_R(1) + (N*(posisi_R(2)-1)), posisi_R(3)) = 200; % Marking Titik Tersebut sudah di expand

                    % Mencari Waktu Tempuh di Sekeliling Titik
                    TravelTimesCalc_R = fdeikonal3Drev(N,Nh,scale,posisi_R,waktu_R,Sinverted,TravelTimesCalc_R);
                end
                disp(['Menghitung Travel Time ', num2str(counter),' dari ',num2str((b*5)*(b*5-1)), ' iterasi ke ',num2str(k)])
                TravelTimeCalc(counter,1) = TravelTimesCalc_S((Receiver(1,q)+1) + (N*(Receiver(2,q))), Receiver(3,q));
                TravelTimesCalc_S2(:,:,counter) = TravelTimesCalc_S;
                TravelTimesCalc_R2(:,:,counter) = TravelTimesCalc_R;
                counter = counter + 1;
                %if counter == 500 || 1000
                %    pause(5);
                %end
            end
        end
    end
    
    %% Mencari Fungsi Pemberat Revisi
    weight_rev = zeros(N*N,Nh,(b*5)*(b*5-1),1);
    weight_rev = FindWeight3D(weight_rev,N,Nh,b,TravelTimeCalc,TravelTimesCalc_S2,TravelTimesCalc_R2,freq,size(TravelTimeCalc,1));
    %if rotate == 1
    %    weight_rev_r = zeros(N,N,b*(b-1));
    %    weight_rev_r = FindWeight(weight_rev_r,N,b,TravelTimeCalc_r,TravelTimesCalc_S2_r,TravelTimesCalc_R2_r,freq,size(TravelTimeCalc_r,1));
    %    weight_rev = cat(3,weight_rev, weight_rev_r);
    %    TravelTimeCalc = cat(1, TravelTimeCalc, TravelTimeCalc_r);
    %end
    % travel time residual
    delta_Time = TravelTime - TravelTimeCalc;
    
    % perhitungan sigma dari Lij
    delta_S = zeros(N,N,Nh);
    for h = 1:Nh
        for j=1:N
            for i=1:N
                pembilang = 0;
                pembilang2 = 0;
                penyebut = 0;
                if rotate == 0
                    total_waktu = (b*5)*(b*5-1);
                elseif rotate == 1
                    total_waktu = 2*(b*5)*(b*5-1);
                end
                for counter = 1:total_waktu
                    pembilang = pembilang + (weight_rev((i+(N*(j-1))),h,counter) * delta_Time(counter,1) / TravelTimeCalc(counter,1));
                    penyebut = penyebut + (weight_rev((i+(N*(j-1))),h,counter));
                end
                if penyebut ~= 0
                    delta_S(i,j,h) = (Sinverted(i,j,h)*pembilang)/penyebut;
                end
            end
        end
    end
    
    % menyimpan slowness lama, membuat slowness sel setelah iterasi ke k
    Sold = Sinverted;
    Sinverted = Sinverted + delta_S;
    
    % menyimpang nilai slowness di iterasi 2,5,10,dan 20
    if k == 2 || k == 5 || k == 10 || k == 20
        Sakhir2_5_10_20(:,:,:,k_inspect) = Sinverted;
        k_inspect = k_inspect + 1;
    end
    
    % perhitungan nilai error
    % perhitungan sigma((Vnew-Vold)/Vold)=
    k = k + 1;
    Stiapiterasi(:,:,:,k) = Sinverted;
    E=[];
    Eall = [];
    abc = 0;
    for h = 1:Nh
        for j=1:N
            for i=1:N
                if Smodel(i,j,h) < 1/(341*1000)
                    E(i,j,h) = ((Sinverted(i,j,h)-Smodel(i,j,h))/Smodel(i,j,h))^2;
                    abc = abc+1;
                end
                Eall(i,j,h) = ((Sinverted(i,j,h)-Smodel(i,j,h))/Smodel(i,j,h))^2;
            end
        end
    end
    
    sig_E = sum(E(:));
    sig_Eall = sum(Eall(:));
    delta_Vall = sig_Eall/length(Eall);
    error = (sqrt(sig_E/length(E(:))))*100;
    errorall = sqrt(sum(delta_Vall)/length(delta_Vall))*100;
    
    mat_k = [mat_k k];
    mat_error = [mat_error error];
    mat_errorall = [mat_errorall errorall];
    
    E_time = [];
    E_time_residual = [];
    time_iteration = TravelTimeCalc;
    if rotate == 0
        total_waktu = (b*5)*(b*5-1);
    elseif rotate == 1
        total_waktu = 2*(b*5)*(b*5-1);
    end
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
    stopwatch(k) = toc;
    pause(30);
end

%% Find Error (Disabled
%{
mat_error_rel = [];
Erel = [];
for n = 1:20
    for h = 1:Nh
        for j=1:N
            for i=1:N
                if Smodel(i,j,h) < 1/(341*1000)
                    Erel(i,j,h) = abs((Stiapiterasi(i,j,h,n)-Sinverted(i,j,h))/Stiapiterasi(i,j,h,n));
                end
            end
        end
    end
    sig_Erel = sum(Erel(:));
    error_rel = (sig_Erel/abc)*100;
    mat_error_rel = [mat_error_rel error_rel];
    Sinverted(:,:,:) = Stiapiterasi(:,:,:,n);
end
%}

%% Plot Error Time RMS (Disabled)
%{
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
%}


%% Plot Final Inverted Model
Title = strcat('Model Akhir MSIRT');
Vplot = 1./(1000*Sinverted);

figure;
Title = strcat('Model Akhir MSIRT');
Slice3D_Model(Title,xx,yy,zz,Sinverted,N,Nh);

figure;
Title = strcat('Model Akhir MSIRT');
Silinder3D_Model(Title,N,Nh,Sinverted)

figure;
Title = strcat('Model Akhir MSIRT');
Silinder3D_Model_custom(Title,N,Nh,Sinverted,custom123)

filename = '3DSilinder_FractureOil2.gif';
for n = 0:1:30
    if n == 0
        Title = strcat('Model MSIRT Iterasi ke - ',num2str(n),' Error : ',num2str(mat_error(n+1)),' %',' time(s) = ',num2str(0));
        figur = figure('Name', Title, 'color', 'white','NumberTitle','off');
        %Slice3D_Model(Title,xx,yy,zz,Sinverted,N,Nh)
        Silinder3D_Model(Title,N,Nh,Sinverted)
        title(Title);

        frame = getframe(figur); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
        pause(0.5);
    else
        Title = strcat('Model MSIRT Iterasi ke - ',num2str(n),' Error : ',num2str(mat_error(n+1)),' %',' time(s) = ',num2str(stopwatch(n)));
        figur = figure('Name', Title, 'color', 'white','NumberTitle','off');
        %Slice3D_Model(Title,xx,yy,zz,Stiapiterasi(:,:,:,n),N,Nh)
        Silinder3D_Model(Title,N,Nh,Stiapiterasi(:,:,:,n))
        title(Title);

        frame = getframe(figur); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        pause(0.5);
    end
    close all;
end