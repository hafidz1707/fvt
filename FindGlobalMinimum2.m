function [posisi_minimum, time_minimum] = FindGlobalMinimum2(TravelTimesTable,FrozenGrid)

Matrix = TravelTimesTable + FrozenGrid;
[time_minimum, pos] = min(Matrix(:));
[Y,X] = ind2sub([size(Matrix,1) size(Matrix,2)],pos); 
posisi_minimum = [Y,X]; % this is your minimum value