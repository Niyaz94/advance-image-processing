clear;
I = imread('cameraman.tif');
im=double(I);
rows=size(im,1);
cols=size(im,2);
feature=[];


%Calculate the Gradient Images
Ix = imfilter(im,[-1,0,1]);
Iy = imfilter(im,-[-1,0,1]');
angle=atand(Ix./Iy); 
magnitude=sqrt(Ix.^2 + Iy.^2);
angle=imadd(angle,90); 
angle(isnan(angle))=0;
angle(angle==180)=0;


% Iterations for Blocks
for i = 0: rows/8 - 2
    for j= 0: cols/8 -2        
        mag_patch = magnitude(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);
        %mag_patch = imfilter(mag_patch,gauss);
        ang_patch = angle(8*i+1 : 8*i+16 , 8*j+1 : 8*j+16);
        block_feature=[];
        %Iterations for cells in a block. the loop work 4 time each
        %itearation for a cell
        for x= 0:1
            for y= 0:1
                %findind specific cell in the block
                angleA =ang_patch(8*x+1:8*x+8, 8*y+1:8*y+8);
                magA   =mag_patch(8*x+1:8*x+8, 8*y+1:8*y+8); 
                histr  =zeros(1,9);
                %Iterations for pixels in one cell
                for p=1:8
                    for q=1:8
                        alpha= angleA(p,q);
                        if alpha>10 && alpha<=30
                            histr(1)=histr(1)+ magA(p,q)*(30-alpha)/20;
                            histr(2)=histr(2)+ magA(p,q)*(alpha-10)/20;
                        elseif alpha>30 && alpha<=50
                            histr(2)=histr(2)+ magA(p,q)*(50-alpha)/20;                 
                            histr(3)=histr(3)+ magA(p,q)*(alpha-30)/20;
                        elseif alpha>50 && alpha<=70
                            histr(3)=histr(3)+ magA(p,q)*(70-alpha)/20;
                            histr(4)=histr(4)+ magA(p,q)*(alpha-50)/20;
                        elseif alpha>70 && alpha<=90
                            histr(4)=histr(4)+ magA(p,q)*(90-alpha)/20;
                            histr(5)=histr(5)+ magA(p,q)*(alpha-70)/20;
                        elseif alpha>90 && alpha<=110
                            histr(5)=histr(5)+ magA(p,q)*(110-alpha)/20;
                            histr(6)=histr(6)+ magA(p,q)*(alpha-90)/20;
                        elseif alpha>110 && alpha<=130
                            histr(6)=histr(6)+ magA(p,q)*(130-alpha)/20;
                            histr(7)=histr(7)+ magA(p,q)*(alpha-110)/20;
                        elseif alpha>130 && alpha<=150
                            histr(7)=histr(7)+ magA(p,q)*(150-alpha)/20;
                            histr(8)=histr(8)+ magA(p,q)*(alpha-130)/20;
                        elseif alpha>150 && alpha<=170
                            histr(8)=histr(8)+ magA(p,q)*(170-alpha)/20;
                            histr(9)=histr(9)+ magA(p,q)*(alpha-150)/20;
                        elseif alpha>=0 && alpha<=10
                            histr(1)=histr(1)+ magA(p,q)*(alpha+10)/20;
                            histr(9)=histr(9)+ magA(p,q)*(10-alpha)/20;
                        elseif alpha>170 && alpha<=180
                            histr(9)=histr(9)+ magA(p,q)*(190-alpha)/20;
                            histr(1)=histr(1)+ magA(p,q)*(alpha-170)/20; 
                        end
                    end
                end
                % Concatenation of Four histograms to form one block feature  the last output will be 1*36         
                block_feature=[block_feature histr];
            end
        end
        % Normalize the values in the block using L1-Norm
        block_feature=block_feature/sqrt(norm(block_feature)^2);    
        feature=[feature block_feature]; %Features concatenation
    end
end

feature(isnan(feature))=0; %Removing Infinitiy values     

