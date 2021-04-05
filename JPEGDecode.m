function imgint = JPEGDecode( code,width,height,quant)

load ACpara.mat

truerow = height/8; 
truecol = width/8;
isBlockStart = 1; 
BlockPoint = 1; 
BlockRow = 1; 
BlockCol = 1; 
intBlock = []; 
DCFomer = 0; 
DCLen = 0; 
ACLen = 0; 
for k = 1 : 64
    intBlock(k) = 0; 
end
i = 1; 
j = 1; 

while 1
    if isBlockStart == 1 
        i = i + DCLen + ACLen;
        if (i >= length(code))
            break;
        end
        ACLen = 0;
        j = 1;
        DCcode = '';
        dcint = []; 
        while 1 
            id = ismember(DC,code(i:i + j));
            [m,n] = find (id == 1); 
            if isempty(m)
                j = j + 1;
            else
                DCPre = code(i:i + j); 
                DCLen = DClength(n); 
                if DCLen == 0
                    DCpara = 0;
                    break
                end
                DCcode(1,1:DCLen) = code(i + j + 1:i + j + DCLen); 
                DCpara = 0; 
                for m = 1 : DCLen 
                    dcint(m) = str2num(DCcode(m));
                end
                if dcint(1) == 1 
                    for m = 1:DCLen
                        DCpara = DCpara + dcint(m) * 2 ^ (DCLen - m);
                    end
                else
                    for m = 1:DCLen
                        if dcint(m) == 0
                            dcint(m) = 1;
                        else
                            dcint(m) = 0;
                        end
                        DCpara = DCpara + dcint(m) * 2 ^ (DCLen - m);
                    end
                    DCpara = -DCpara;
                end
                break
            end
        end
        isBlockStart = 0;
        BlockPoint = BlockPoint + 1;
        intBlock(1) = DCpara + DCFomer;
        DCFomer = intBlock(1);
        
    else
        i = i + j + DCLen + ACLen + 1;
        if (i >= length(code))
            break;
        end
        DCLen = 0;
        ACcode = '';
        acint = [];
        j = 1;
        while 1
            id = ismember(AC,code(i:i + j));
            [m,n] = find (id == 1);
            if isempty(m)
                j = j + 1;
            elseif m == 1 & n == 1 
                BlockPoint = 64;
                ACLen = 4;
                ACpara = 0;
                runlength = 0;
                break
            elseif m == 16 & n == 1 
                runlength = 15;
                ACpara = 0;
                ACLen = 0;
                break;
            else
                ACPre = code(i:i + j);
                runlength = m - 1;
                ACLen = AClength(n - 1);
                ACcode(1,1:ACLen) = code(i + j + 1:i + j + ACLen);
                ACpara = 0;
                for m = 1 : ACLen
                    acint(m) = str2num(ACcode(m));
                end
                if acint(1) == 1
                    for m = 1:ACLen
                        ACpara = ACpara + acint(m) * 2 ^ (ACLen - m);
                    end
                else
                    for m = 1:ACLen
                        if acint(m) == 0
                            acint(m) = 1;
                        else
                            acint(m) = 0;
                        end
                        ACpara = ACpara + acint(m) * 2 ^ (ACLen - m);
                    end
                    ACpara = -ACpara;
                end
                break
            end
        end

        intBlock(BlockPoint + runlength) = ACpara;
        if BlockPoint == 64
            isBlockStart = 1;
            BlockPoint = 0;
            q = invZigzag(intBlock); 
            dct = JPEGiQuantification(q,quant); 
            blockint = JPEGiDCT(dct); 
            blockint = round(blockint);
            imgint((BlockRow-1)*8+1:BlockRow*8,(BlockCol-1)*8+1:BlockCol*8) = blockint; %´æ´¢½âÂëÖµ
            if BlockCol == truecol
                BlockCol = 1;
                if BlockRow == truerow
                    break 
                end
                BlockRow = BlockRow + 1;
            else
                BlockCol = BlockCol + 1;
            end
            intBlock(1:64) = 0;
            BlockRow,BlockCol
        end 
        BlockPoint = BlockPoint + runlength + 1;
    end
    if (i >= length(code))
        break;
    end
end

[width,height] = size(imgint);
for i = 1 : width
    for j = 1 : height
        if imgint(i,j) < 0
            imgint(i,j) = 0; 
        end
    end
end
imgint = uint8(imgint); 
