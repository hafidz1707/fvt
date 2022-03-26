function [posisi_minimum, time_minimum] = FindGlobalMinimum3D(N,TravelTimesTable,FrozenGrid)

Matrix = TravelTimesTable + FrozenGrid;
[time_minimum, pos] = min(Matrix(:));
[YX,Z] = ind2sub([size(Matrix,1) size(Matrix,2)],pos);
Y = ceil(YX/N); % Posisi grid di X
X = mod(YX,N); % Posisi grid di Y
if X == 0
    X = N;
end
posisi_minimum = [X,Y,Z]; % this is your minimum value