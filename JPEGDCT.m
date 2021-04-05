function X = JPEGDCT(x)
[rows,cols] = size(x);
c = [1/sqrt(2) 1 1 1 1 1 1 1];



for i = 1:rows
    for j = 1:cols
        A(i,j) = sqrt(2/rows) * c(i) * cos(((j- 1) + 0.5) * pi * (i-1) / rows);
    end
end

X = A * x * A';