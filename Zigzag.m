function ZZ = Zigzag( zz )
%ZIGZAG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

index=reshape(1:numel(zz),size(zz));
index=fliplr(spdiags(fliplr(index)));
index(:,1:2:end)=flipud(index(:,1:2:end));
index(index==0)=[];
ZZ=zz(index);

end
