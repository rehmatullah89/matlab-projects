%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function calling image
function [d]=lpcseg(jpg)
I=imread('car.jpg');
I1=rgb2gray(I);
I2=edge(I1,'robert',0.15,'both');
se=[1;1;1];
I3=imerode(I2,se);
se=strel('rectangle',[25,25]);
I4=imclose(I3,se);
I5=bwareaopen(I4,2000);
[y,x,z]=size(I5);
myI=double(I5);
tic
 white_y=zeros(y,1);
 for i=1:y
    for j=1:x
             if(myI(i,j,1)==1) 
                white_y(i,1)= white_y(i,1)+1; 
            end  
     end       
 end
 [temp MaxY]=max(white_y);
 PY1=MaxY;
 while ((white_y(PY1,1)>=5)&&(PY1>1))
        PY1=PY1-1;
 end    
 PY2=MaxY;
 while ((white_y(PY2,1)>=5)&&(PY2<y))
        PY2=PY2+1;
 end
 IY=I(PY1:PY2,:,:);
 white_x=zeros(1,x);
 for j=1:x
     for i=PY1:PY2
            if(myI(i,j,1)==1)
                white_x(1,j)= white_x(1,j)+1;               
            end  
     end       
 end
  
 PX1=1;
 while ((white_x(1,PX1)<3)&&(PX1<x))
       PX1=PX1+1;
 end    
 PX2=x;
 while ((white_x(1,PX2)<3)&&(PX2>PX1))
        PX2=PX2-1;
 end
 PX1=PX1-1;
 PX2=PX2+1;
  dw=I(PY1:PY2-8,PX1:PX2,:);
 t=toc; 
figure(1),subplot(3,2,1),imshow(dw),title('Number_Plate')
imwrite(dw,'dw.jpg');
[filename,filepath]=uigetfile('dw.jpg','written_image');
jpg=strcat(filepath,filename);
a=imread(jpg);
%figure(1);subplot(3,2,1),imshow(a)
b=rgb2gray(a);
imwrite(b,'grey_scaled_image.jpg');
figure(1);subplot(3,2,2),imshow(b),title('grey_scaled_image')
g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3);
[m,n]=size(b);
d=(double(b)>=T);  
imwrite(d,'Position_of_no_Plate.jpg');
figure(1);subplot(3,2,3),imshow(d),title('Position_of_no_Plate')

%
rotate=0;
d=imread('Position_of_no_Plate.jpg');
bw=edge(d);
[m,n]=size(d);
theta=1:179;
% bw 
i=find(r>0);
[foo,ind]=sort(-r(i));
k=i(ind(1:size(i)));
[y,x]=ind2sub(size(r),k);
[mm,nn]=size(x);
if mm~=0 && nn~=0
    j=1;
    while mm~=1 && j<180 && nn~=0
        i=find(r>j);
        [foo,ind]=sort(-r(i));
        k=i(ind(1:size(i)));
        [y,x]=ind2sub(size(r),k);
        [mm,nn]=size(x);
        j=j+1;
    end
    if nn~=0
        if x   % Enpty matrix: 0-by-1 when x is an enpty array
            x=x;
        else  
            x=90; 
        end
        d=imrotate(d,abs(90-x));
        rotate=1;
    end
end
imwrite(d,'4image.jpg');
figure(1),subplot(3,2,4),imshow(d),title('4image')

% 
[m,n]=size(d);
% flag=0
flag=0;
c=d([round(m/3):m-round(m/3)],[round(n/3):n-round(n/3)]);
if sum(sum(c))/m/n*9>0.5
    d=~d;flag=1;
end
% 
if flag==1
    for j=1:n
        if sum(sum(d(:,j)))/m>=0.95
            d(:,j)=0;
        end
    end
    % 
    jj=0;
    for j=1:round(n/2)
        if sum(sum(d(:,[j:j+0])))==0
            jj=j;
        end
    end
    d(:,[1:jj])=0;
    % 
    for j=n:-1:round(n/2)
        if sum(sum(d(:,[j-0:j])))==0
            jj=j;
        end
    end
    d(:,[jj:n])=0;
end
imwrite(d,'5image.jpg');
figure(1),subplot(3,2,5),imshow(d),title('5image_1')
figure(2),subplot(5,1,1),imshow(d),title('5image_2')

% 
y1=10;  
for i=1:round(m/5*2)
    count=0;jump=0;temp=0;
    for j=1:n
        if d(i,j)==1
            temp=1;
        else
            temp=0;
        end
        if temp==jump
            count=count;
        else
            count=count+1;
        end
        jump=temp;
    end
    if count<y1
        d(i,:)=0;
    end
end
%
for i=3*round(m/5):m
    count=0;jump=0;temp=0;
    for j=1:n
        if d(i,j)==1
            temp=1;
        else
            temp=0;
        end
        if temp==jump
            count=count;
        else
            count=count+1;
        end
        jump=temp;
    end
    if count<y1
        d(i,:)=0;
    end
end
imwrite(d,'6image.jpg');
figure(2),subplot(5,1,2),imshow(d),title('6image')

% STEP 2  
y2=round(n/2); 
for i=1:round(m/5*2)
    if flag==0
        temp=sum(d(i,:));y2=round(n/2);
        if temp>y2
            d(i,:)=0;
        end
    else
        temp=m-sum(d(i,:));y2=m-round(n/2);
        if temp<y2
            d(i,:)=0;
        end
    end
end
% 
for i=round(3*m/5):m
    if flag==0
        temp=sum(d(i,:));y2=round(n/2);
        if temp>y2
            d(i,:)=0;
        end
    else
        temp=m-sum(d(i,:));y2=m-round(n/2);
        if temp<y2
            d(i,:)=0;
        end
    end
end
imwrite(d,'7image.jpg');
figure(2),subplot(5,1,3),imshow(d),title('7image')
% STEP 3  
y2=round(n/2); 
for i=1:round(m/5*2)
    if flag==0
        temp=sum(d(i,:));y2=round(n/2);
        if temp>y2
            d(i,:)=0;
        end
    else
        temp=m-sum(d(i,:));y2=m-round(n/2);
        if temp<y2
            d(i,:)=0;
        end
    end
end
% 
for i=round(3*m/5):m
    if flag==0
        temp=sum(d(i,:));y2=round(n/2);
        if temp>y2
            d(i,:)=0;
        end
    else
        temp=m-sum(d(i,:));y2=m-round(n/2);
        if temp<y2
            d(i,:)=0;
        end
    end
end
imwrite(d,'8image.jpg');
figure(2),subplot(5,1,4),imshow(d),title('8image')
%  STEP 4 
for i=1:round(m/2)
    if sum(sum(d([i,i+0],:)))==0
        ii=i;
    end
end
d([1:ii],:)=0;
% 
for i=m:-1:round(m/2)
    if sum(sum(d([i-0:i],:)))==0
        ii=i;
    end
end
d([ii:m],:)=0;
imwrite(d,'9image.jpg');
figure(2),subplot(5,1,5),imshow(d),title('9image')

% 
if rotate==1
    d=imrotate(d,-abs(x-90));
end
imwrite(d,'10image.jpg');
figure(3),subplot(3,2,1),imshow(d),title('10image')
% 
d=qiege(d);e=d;
imwrite(d,'11image.jpg');
figure(3),subplot(3,2,2),imshow(d),title('11image')
figure(3),subplot(3,2,3),imshow(d),title('11image_2')

% 
h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));
imwrite(d,'12image.jpg');
figure(3),subplot(3,2,4),imshow(d),title('12image')


% se=strel('square',3); 
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix 
[m,n]=size(d);
if bwarea(d)/m/n>=0.365
    d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    d=imdilate(d,se);
end
imwrite(d,'13image.jpg');
figure(3),subplot(3,2,5),imshow(d),title('13image')

%
d=qiege(d);
[m,n]=size(d);
figure,subplot(2,1,1),imshow(d),title(n)
k1=1;k2=1;s=sum(d);j=1;
while j~=n
    while s(j)==0
        j=j+1;
    end
    k1=j;
    while s(j)~=0 && j<=n-1
        j=j+1;
    end
    k2=j-1;
    if k2-k1>=round(n/6.5)
        [val,num]=min(sum(d(:,[k1+5:k2-5])));
        d(:,k1+num+5)=0;  
    end
end
% 
d=qiege(d);
% 
y1=10;y2=0.25;flag=0;word1=[];
while flag==0
    [m,n]=size(d);
    left=1;wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
    if wide<y1  
        d(:,[1:wide])=0;
        d=qiege(d);
    else
        temp=qiege(imcrop(d,[1 1 wide m]));
        [m,n]=size(temp);
        all=sum(sum(temp));
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
        if two_thirds/all>y2
            flag=1;word1=temp;   % WORD 1
        end
        d(:,[1:wide])=0;d=qiege(d);
    end
end
% 
[word2,d]=getword(d);
% 
[word3,d]=getword(d);
% 
[word4,d]=getword(d);
% 
[word5,d]=getword(d);
% 
[word6,d]=getword(d);
%
[word7,d]=getword(d);
subplot(5,7,1),imshow(word1),title('1');
subplot(5,7,2),imshow(word2),title('2');
subplot(5,7,3),imshow(word3),title('3');
subplot(5,7,4),imshow(word4),title('4');
subplot(5,7,5),imshow(word5),title('5');
subplot(5,7,6),imshow(word6),title('6');
subplot(5,7,7),imshow(word7),title('7');
[m,n]=size(word1);
% 
word1=imresize(word1,[40 20]);
word2=wordprocess(word2);
word3=wordprocess(word3);
word4=wordprocess(word4);
word5=wordprocess(word5);
word6=wordprocess(word6);
word7=wordprocess(word7);


subplot(5,7,15),imshow(word1),title('1');
subplot(5,7,16),imshow(word2),title('2');
subplot(5,7,17),imshow(word3),title('3');
subplot(5,7,18),imshow(word4),title('4');
subplot(5,7,19),imshow(word5),title('5');
subplot(5,7,20),imshow(word6),title('6');
subplot(5,7,21),imshow(word7),title('7');
imwrite(word1,'14image 1.jpg');
imwrite(word2,'14image 2.jpg');
imwrite(word3,'14image 3.jpg');
imwrite(word4,'14image 4.jpg');
imwrite(word5,'14image 5.jpg');
imwrite(word6,'14image 6.jpg');
imwrite(word7,'14image 7.jpg');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
word='';
word(1)=wordrec(word1);
word(2)=wordrec(word2);
word(3)=wordrec(word3);
word(4)=wordrec(word4);
word(5)=wordrec(word5);
word(6)=wordrec(word6);
word(7)=wordrec(word7);
clc
save I  'word1' 'word2' 'word3' 'word4' 'word5' 'word6' 'word7'
clear
load I;
load bp net;
word='';
word(1)=wordrec(word1);
word(2)=wordrec(word2);
word(3)=wordrec(word3);
word(4)=wordrec(word4);
word(5)=wordrec(word5);
word(6)=wordrec(word6);
word(7)=wordrec(word7);
word=strcat('Ê¶±ð½á¹û:',word);
subplot(5,3,14),imshow([]),title(word,'fontsize',24)

% 
function e=qiege(d)
[m,n]=size(d);
top=1;bottom=m;left=1;right=n;   % init
while sum(d(top,:))==0 && top<=m
    top=top+1;
end
while sum(d(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
while sum(d(:,left))==0 && left<=n
    left=left+1;
end
while sum(d(:,right))==0 && right>=1
    right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);

% 
function [word,result]=getword(d)
word=[];flag=0;y1=8;y2=0.5;
% if d==[]
%   word=[];
% else
    while flag==0
        [m,n]=size(d);
        wide=0;
        while sum(d(:,wide+1))~=0 && wide<=n-2
            wide=wide+1;
        end
        temp=qiege(imcrop(d,[1 1 wide m]));
        [m1,n1]=size(temp);
        if wide<y1 && n1/m1>y2
            d(:,[1:wide])=0;
            if sum(sum(d))~=0
                d=qiege(d);  
            else word=[];flag=1;
            end
        else
            word=qiege(imcrop(d,[1 1 wide m]));
            d(:,[1:wide])=0;
            if sum(sum(d))~=0;
                d=qiege(d);flag=1;
            else d=[];
            end
        end
    end
%end
          result=d;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
function d=wordprocess(d)
[m,n]=size(d);
%top 1/3, bottom 1/3
for i=1:round(m/3)
    if sum(sum(d([i:i+0],:)))==0
        ii=i;d([1:ii],:)=0;
    end
end
for i=m:-1:2*round(m/3)
    if sum(sum(d([i-0:i],:)))==0
        ii=i;d([ii:m],:)=0;
    end
end
if n~=1
    d=qiege(d);
end

% d=imresize(d,[32 16]); 
d=imresize(d,[40 20]); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 
% 60 61 62 63 64 65 66 67 68 69 70

function word=wordrec(xx)
% clear
% clc
load bp net;
xx=im2bw(xx);xx=double(xx(:));  
a=sim(net,xx);  
[val,num]=max(a);
if num<=26
    word=char(double('A')+num-1);
elseif num<=36
    word=char(double('0')+num-1-26);
else
    switch num
        case 37
            word='¾©';
        case 38
            word='½ò';
        case 39
            word='»¦';
        case 40
            word='Óå';
        case 41
            word='¸Û';
        case 42
            word='°Ä';
        case 43
            word='¼ª';
        case 44
            word='ÁÉ';
        case 45
            word='Â³';
        case 46
            word='Ô¥';
        case 47
            word='¼½';
        case 48
            word='¶õ';
        case 49
            word='Ïæ';
        case 50
            word='½ú';
        case 51
            word='Çà';
        case 52
            word='Íî';
        case 53
            word='ËÕ';
        case 54
            word='¸Ó';
        case 55
            word='Õã';
        case 56
            word='Ãö';
        case 57
            word='ÔÁ';
        case 58
            word='Çí';
        case 59
            word='Ì¨';
        case 60
            word='ÉÂ';
        case 61
            word='¸Ê';
        case 62
            word='ÔÆ';
        case 63
            word='´¨';
        case 64
            word='¹ó';
        case 65
            word='ºÚ';
        case 66
            word='²Ø';
        case 67
            word='ÃÉ';
        case 68
            word='¹ð';
        case 69
            word='ÐÂ';
        case 70
            word='Äþ';
    end
end