function Q = mask10( q )

QMatrix = [1 1 1 1 0 0 0 0;
           1 1 1 0 0 0 0 0;
           1 1 0 0 0 0 0 0;
           1 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0];
       Q = q.*QMatrix;
end