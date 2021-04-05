function code = JPEGEncode( Coefficient,FormerDC )

load ACpara.mat
if nargin == 1
    FormerDC = 0;
end

isDCNeg = 0; 
DCStr = '';  
DC = Coefficient(1) - FormerDC;    

if DC < 0
    DC = -DC;
    isDCNeg = 1;
end

if DC == 0
    DCFormerStr = '00';
elseif DC <= 1
    DCFormerStr = '010';
elseif DC <= 3
    DCFormerStr = '011';
elseif DC <= 7
    DCFormerStr = '100';
elseif DC <= 15
    DCFormerStr = '101';
elseif DC <= 31
    DCFormerStr = '110';
elseif DC <= 63
    DCFormerStr = '1110';
elseif DC <= 127
    DCFormerStr = '11110';
elseif DC <= 255
    DCFormerStr = '111110';
elseif DC <= 511
    DCFormerStr = '1111110';
elseif DC <= 1023
    DCFormerStr = '11111110';
elseif DC <= 2047
    DCFormerStr = '111111110';
end

DCSuf = '';
while DC > 0
    x = rem(DC,2);
    DC = floor(DC/2);
    if x ==0
        a = '0';
    else
        a = '1';
    end
    DCSuf = [DCSuf,a];
end
DCSuf = DCSuf(end:-1:1);
if isDCNeg == 1
    for k = 1 : length(DCSuf)
        if DCSuf(k) == '0'
            DCSuf(k) = '1';
        else
            DCSuf(k) = '0';
        end
    end
end
DCStr = [DCFormerStr,DCSuf];

NotZero = find (Coefficient ~= 0);
[x,num] = size(NotZero);
ACStr = '';
for i = 1:num
    if NotZero(i) ~= 1
        
        if i == 1
            RunLength = NotZero(i) - 2;
        elseif NotZero(i) > NotZero(i-1) - 1
            RunLength = NotZero(i) - NotZero(i-1) - 1;
        else
            RunLength = 0;
        end
        
        
        ACCoe = Coefficient(NotZero(i));  
        isACNeg = 0;    
        if ACCoe < 0
            ACCoe = -ACCoe;
            isACNeg = 1;
        end
        if ACCoe <= 1
            SizeAC = 1;
        elseif ACCoe <=3
            SizeAC = 2;
        elseif ACCoe <=7
            SizeAC = 3;
        elseif ACCoe <=15
            SizeAC = 4;
        elseif ACCoe <=31
            SizeAC = 5;
        elseif ACCoe <=63
            SizeAC = 6;
        elseif ACCoe <=127
            SizeAC = 7;
        elseif ACCoe <=255
            SizeAC = 8;
        elseif ACCoe <=511
            SizeAC = 9;
        elseif ACCoe <=1023
            SizeAC = 10;
        end
        ACFormerStr = '';
        while RunLength > 15
            RunLength = RunLength - 16;
            ACFormerStr = [ACFormerStr, AC{16,1}];
        end
        ACFormerStr = [ACFormerStr, AC{RunLength+1, SizeAC+1}];
        ACSuf = '';
        while ACCoe > 0
            x = rem(ACCoe,2);
            ACCoe = floor(ACCoe/2);
            if x ==0
                a = '0';
            else
                a = '1';
            end
            ACSuf = [ACSuf,a];
        end
        ACSuf = ACSuf(end:-1:1);
        if isACNeg == 1
            for k = 1 : length(ACSuf)
                if ACSuf(k) == '0'
                    ACSuf(k) = '1';
                else
                    ACSuf(k) = '0';
                end
            end
        end
        ACStr = [ACStr, ACFormerStr,ACSuf];
    else
        continue;
    end
end
if NotZero(num) ~= 64
    ACLast = AC{1,1};
end
ACStr = [ACStr, ACLast];
    

code = [DCStr,ACStr];