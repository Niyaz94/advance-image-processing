%% Creating a simple image
clear
im = zeros(101,101);
im(1,1) = 1;
im(1,end) = 1;
im(end,1) = 1;
im(end,end) = 1;
im(floor(end/2),floor(end/2)) = 1;
%% Initializing other parameters
theta = ((-90:90)./180).*pi;

%length of the diagonal of image
%DiagLen = hypot(size(im,1),size(im,2))% Invoke Euclid To Get The Diagonal Length

D = sqrt(size(im,1).^2 + size(im,2).^2);

HS = zeros(ceil(2.*D),numel(theta));

% find the index of non zero pixels
[y,x] = find(im);
% subtract all the items in array by one
y = y - 1;
x = x - 1;
% numel(x) ---> get the lenght of array
%A cell array is a data type with indexed data containers called cells, where each cell can contain any type of data. Cell arrays commonly contain either lists of character vectors of different lengths, or mixes of strings and numbers, or numeric arrays of different sizes.
rho = cell(1,numel(x));



%% Calculating the Hough Transform
for i = 1: numel(x)
    rho{i} = x(i).*cos(theta) + y(i).*sin(theta); % [-sqrt(2),sqrt(2)]*D rho interval
end

%% Creating the Hough Space as an Image
for i = 1:numel(x)
    %converting minus value to posative becuase we don't have row with
    %minus index in image
    rho{i} = floor(rho{i}+ D) + 1;
    for j = 1:numel(rho{i})
        HS(rho{i}(j),j) = HS(rho{i}(j),j) + 1; 
    end
end

figure
imshow(HS)
