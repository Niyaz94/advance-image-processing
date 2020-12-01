clear();

%this section is useful if we have points.
%{
    Points = [1 1;1.5 1.5;5 5;3 4;4 4;3 3.5];
    Dist=zeros(size(Points,1),size(Points,1));
    for i = 1:size(Points,1)
        for j = 1:size(Points,1)
            Dist(i,j)=sqrt(power((Points(i,1)-Points(j,1)),2)+(Points(i,2)-Points(j,2)).^2);
        end
    end
    NEW_DIST=zeros(size(Points,1)-1,size(Points,1)-1);
%}

Dist= [0 1 3 4 5;1 0 2 3 4;3 2 0 1 2;4 3 1 0 1; 5 4 2 1 0];
NEW_DIST=zeros(size(Dist,1)-1,size(Dist,1)-1);
ALL_Tables{1}=Dist;

k=1;
%change the algorithm you can choose one of them {average, min, max}
algorithm_type="average";

% create infinte loop
while k==1
    %stop the loop if the matrix size less than zero
    if size(NEW_DIST,1)<=1
        break;
    end
    % getting the lower part of matrix diagonal
    Min_value=tril(Dist,-1);
    % convert the zeros to nan, it is useful for choosing min value
    Min_value(Min_value==0)=nan;
    %find the x,y indexes of the min values
    [X_index,Y_index]=find(Min_value==min(Min_value(:)));
    
    % maybe we have more than one min value choose the first one
    if length(X_index)>1
        X_index=X_index(1);
        Y_index=Y_index(1);
    elseif ~isnumeric(X_index) % if no min found then break the loop , this case never happen but I added just as sntax sugger
       break;        
    end
    
    for i =1:size(Dist,1)
        for j =1:size(Dist,2)
            % if not below diagonal or is NAN or the value it is self(it happen becuase we have two for loop) then continue
            if i <= j | (X_index==i & Y_index==j) | isnan(Dist(i,j))
                continue;
            end
            
            % find the location of calculated item
            if X_index>=i
                new_index_x=i;
            else
                new_index_x=i-1;
            end
            if Y_index>=j
                new_index_y=j;
            else
                new_index_y=j-1;
            end
            
            if eq(X_index,i) | eq(Y_index,i)
                % calculate depend on the algorithm type
                if algorithm_type=="average"
                    NEW_DIST(new_index_x,new_index_y)=mean([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                elseif algorithm_type=="min"
                    NEW_DIST(new_index_x,new_index_y)=min([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                elseif algorithm_type=="max"
                    NEW_DIST(new_index_x,new_index_y)=max([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                end
                %make them NAN to go throw them again
                Dist(j,X_index)=nan;
                Dist(j,Y_index)=nan;
                Dist(X_index,j)=nan;
                Dist(Y_index,j)=nan;
            elseif eq(Y_index,j) | eq(X_index,j)
                if algorithm_type=="average"
                    NEW_DIST(new_index_x,new_index_y)=mean([Dist(i,X_index),Dist(i,Y_index),Dist(X_index,i),Dist(Y_index,i)]);
                elseif algorithm_type=="min"
                    NEW_DIST(new_index_x,new_index_y)=min([Dist(i,X_index),Dist(i,Y_index),Dist(X_index,i),Dist(Y_index,i)]);
                elseif algorithm_type=="max"
                    NEW_DIST(new_index_x,new_index_y)=max([Dist(i,X_index),Dist(i,Y_index),Dist(X_index,i),Dist(Y_index,i)]);
                end
                Dist(i,X_index)=nan;
                Dist(i,Y_index)=nan;
                Dist(X_index,i)=nan;
                Dist(Y_index,i)=nan;
            else
                NEW_DIST(new_index_x,new_index_y)= Dist(i,j);
            end
        end
    end
    % add the lower part of diagonal into upper part
    NEW_DIST=tril(NEW_DIST,-1)'+NEW_DIST;
    % add the reslt to cell
    ALL_Tables{end+1}=NEW_DIST;
    Dist=NEW_DIST;
    NEW_DIST=zeros(size(Dist,1)-1,size(Dist,1)-1);
end
% show the result in table
for n = 1:numel(ALL_Tables)
    table(ALL_Tables{n})
end



