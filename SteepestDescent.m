function [Gradient] = SteepestDescent(N,h,TravelTimesCalc)
Gradient = zeros(N,N);
for i = 1:N-1
    for j = 1:N-1
        dtdx = (TravelTimesCalc(i,j+1) + TravelTimesCalc(i+1,j+1) - (TravelTimesCalc(i,j) + TravelTimesCalc(i+1,j))) / (2*h);
        dtdz = (TravelTimesCalc(i+1,j) + TravelTimesCalc(i+1,j+1) - (TravelTimesCalc(i,j) + TravelTimesCalc(i,j+1))) / (2*h);
        
        if dtdx >= 0 && dtdz >= 0
            theta = atan(dtdz/dtdx) + pi;
        elseif dtdx >= 0 && dtdz < 0
            theta = atan(dtdz/dtdx) + pi;
        elseif dtdx < 0 && dtdz >= 0
            theta = atan(dtdz/dtdx)  + (2*pi);
        elseif dtdx < 0 && dtdz < 0
            theta = atan(dtdz/dtdx);
        end
        Gradient(i,j) = theta;
    end
end
for i = N
    j = 1:N;
    Gradient(i,j) = Gradient(i-1,j);
    Gradient(j,i) = Gradient(j,i-1);
end
end