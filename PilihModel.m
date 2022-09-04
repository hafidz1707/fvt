function Smodel = PilihModel(N,Smodel,opsi, b)
%{
First Model Option
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
12 = Dead Oil Shear Fracture

%}
if opsi == 1
    for i = (2/5)*(N-1)+1:(6/10)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(3500*1000);
        end
    end

elseif opsi == 2
    for i = (9/20)*(N-1)+1:(11/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(3000*1000); %4000
        end
    end
    for i = (5/20)*(N-1)+1:(7/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(1500*1000);
        end
    end
    for i = (13/20)*(N-1)+1:(15/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(1500*1000);
        end
    end
    for i = (1/20)*(N-1)+1:(3/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(3000*1000);
        end
    end
    for i = (17/20)*(N-1)+1:(19/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(3000*1000);
        end
    end
elseif opsi == 3 % Model Mineral
    % Model Mika Plus // Kalsit Plus
    for i = (20/100)*(N-1)+1:(45/100)*(N-1)+1
        for j = (26/100)*(N-1)+1:(39/100)*(N-1)+1
            Smodel(i,j) = 1/(2200*1000);
        end
    end
    for i = (26/100)*(N-1)+1:(39/100)*(N-1)+1
        for j = (20/100)*(N-1)+1:(45/100)*(N-1)+1
            Smodel(i,j) = 1/(2200*1000);
        end
    end
    % Model Plagioklas Bulat // Kuarsa Bulat
    for i = 30:42
        for j = 65:77
            Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 29:43
        for j = 66:76
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 31:41
        for j = 64:78
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 28:44
        for j = 67:75
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 32:40
        for j = 63:79
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 27:45
        for j = 69:73
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    for i = 34:38
        for j = 62:80
        	Smodel(i,j) = 1/(6050*1000);
        end
    end
    % Model Pirokesen Kotak // Feldspar
    for i = (65/100)*(N-1)+1:(80/100)*(N-1)+1
        for j = (25/100)*(N-1)+1:(40/100)*(N-1)+1
            Smodel(i,j) = 1/(4680*1000);
        end
    end
    
    % Model Void
    for i = (70/100)*(N-1)+1:(70/100)*(N-1)+4
        for j = (70/100)*(N-1)+1:(70/100)*(N-1)+4
            Smodel(i,j) = 1/(340*1000);
        end
    end
elseif opsi == 4 % Model Tangga
    for i = 1:(12/20)*(N-1)+1
        for j = 1:N
            Smodel(j,i) = 1/(1500*1000);
        end
    end
    for i = (8/20)*(N-1)+1:(20/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(1500*1000);
        end
    end
    for i = 1:(8/20)*(N-1)+1
        for j = 1:N
            Smodel(j,i) = 1/(2250*1000);
        end
    end
    for i = (12/20)*(N-1)+1:(20/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(2250*1000);
        end
    end
    for i = 1:(4/20)*(N-1)+1
        for j = 1:N
            Smodel(j,i) = 1/(3000*1000);
        end
    end
    for i = (16/20)*(N-1)+1:(20/20)*(N-1)+1
        for j = 1:N
            Smodel(i,j) = 1/(3000*1000);
        end
    end
    
elseif opsi == 5 % Model Shear Fracture
    j = (6/20)*(N-1)+1;
    for i = (6/20)*(N-1)+1:(14/20)*(N-1)+1
        Smodel(i,j) = 1/(340*1000);
        Smodel(i+1,j) = 1/(340*1000);
        j = j + 1;
    end
    j = (9/20)*(N-1)+1;
    for i = (9/20)*(N-1)+1:(12/20)*(N-1)+1
        Smodel(i+1,j) = 1/(340*1000);
        Smodel(i+1,j+1) = 1/(340*1000);
        j = j - 1;
    end
    i = (11/20)*(N-1)+1;
    for j = (11/20)*(N-1)+1:1:(14/20)*(N-1)+1
        Smodel(round(i),round(j)) = 1/(340*1000);
        Smodel(round(i),round(j)+1) = 1/(340*1000);
        i = i - 1;
    end
%{    
elseif opsi == 5 % Model Shear Fracture
    for i = (5/20)*(N-1)+1:(15/20)*(N-1)+1
        Smodel((10/20)*(N-1)+1,i) = 1/(340*1000);
    end
    for i = (6/20)*(N-1)+1:(10/20)*(N-1)+1
        Smodel(i,round((18/40)*(N-1)+1)) = 1/(340*1000);
    end
    for i = (10/20)*(N-1)+1:(14/20)*(N-1)+1
        Smodel(i,round((22/40)*(N-1)+1)) = 1/(340*1000);
    end
    %}
elseif opsi == 6 % Model Checkerboard 0.2 x 0.2 mm
    % Blackboard
    for j = 1:2:N
        for i = 1:2:N
            Smodel(j,i) = 1/(3000*1000);
        end
    end
    for j = 2:2:N
        for i = 2:2:N
            Smodel(j,i) = 1/(3000*1000);
        end
    end
    % Whiteboard
    for j = 1:2:N
        for i = 2:2:N
            Smodel(j,i) = 1/(1500*1000);
        end
    end
    for j = 2:2:N
        for i = 1:2:N
            Smodel(j,i) = 1/(1500*1000);
        end
    end
    
elseif opsi == 7 % Model Checkerboard 1 x 1 mm
    % Blackboard 1
    for k = 1:5
        for j = k:(N-1)/10:N-1
            for l = 1:5
                for i = l:(N-1)/10:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
    for k = 6:10
        for j = k:(N-1)/10:N-1
            for l = 6:10
                for i = l:(N-1)/10:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
elseif opsi == 8 % Model Checkerboard 2x2 mm
    % Blackboard 1
    for k = 1:10
        for j = k:(N-1)/5:N-1
            for l = 1:10
                for i = l:(N-1)/5:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
    for k = 11:20
        for j = k:(N-1)/5:N-1
            for l = 11:20
                for i = l:(N-1)/5:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
elseif opsi == 9 % Model Checkerboard 3x3 mm
    % Blackboard 1
    for k = 1:15
        for j = k:round((N-1)/3.3):N-1
            for l = 1:15
                for i = l:round((N-1)/3.3):N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
    for k = 16:30
        for j = k:round((N-1)/3.3):N-1
            for l = 16:30
                for i = l:round((N-1)/3.3):N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
elseif opsi == 10 % Model Checkerboard 4x4 mm
    % Blackboard 1
    for k = 1:20
        for j = k:(N-1)/2.5:N-1
            for l = 1:20
                for i = l:(N-1)/2.5:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
    for k = 21:40
        for j = k:(N-1)/2.5:N-1
            for l = 21:40
                for i = l:(N-1)/2.5:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
elseif opsi == 11 % Model Checkerboard 5x5 mm
    % Blackboard 1
    for k = 1:25
        for j = k:(N-1)/2:N-1
            for l = 1:25
                for i = l:(N-1)/2:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end
    for k = 26:50
        for j = k:(N-1)/2:N-1
            for l = 26:50
                for i = l:(N-1)/2:N-1
                    Smodel(j,i) = 1/(3000*1000);
                end
            end
        end
    end    
elseif opsi == 12 % Model Shear Fracture Dead Oil
    load('S_oilshearfracture.mat','Smodel');
end