%X = [1.5 1;1.5 1.5;1.5 2;3 4;4 4;3 3.5];
%Y = pdist(X);
%W = squareform(Y);
%Y = [1 3 4 5 2 3 4 1 2 1]
%Z = linkage(Y);
%I = inconsistent(Z)
%dendrogram(Z);
clear();


%Points = [1 1;1.5 1.5;5 5;3 4;4 4;3 3.5];
%Dist=zeros(size(Points,1),size(Points,1));
Dist= [0 1 3 4 5;1 0 2 3 4;3 2 0 1 2;4 3 1 0 1; 5 4 2 1 0];
%NEW_DIST=zeros(size(Points,1)-1,size(Points,1)-1);
NEW_DIST=zeros(size(Dist,1)-1,size(Dist,1)-1);




%{
for i = 1:size(Points,1)
    for j = 1:size(Points,1)
        Dist(i,j)=sqrt(power((Points(i,1)-Points(j,1)),2)+(Points(i,2)-Points(j,2)).^2);
    end
end
%}
ALL_Tables{1}=Dist;


k=1;
counter=0;
algorithm_type="average";
while k==1
    counter=counter+1;

    if size(NEW_DIST,1)<=1
        break;
    end

    Min_value=tril(Dist,-1);
    Min_value(Min_value==0)=nan;
    [X_index,Y_index]=find(Min_value==min(Min_value(:)));
    

    if length(X_index)>1
        X_index=X_index(1);
        Y_index=Y_index(1);
    elseif ~isnumeric(X_index)
       break;        
    end
    
    
    for i =1:size(Dist,1)
        for j =1:size(Dist,2)

            if i <= j | (X_index==i & Y_index==j) | isnan(Dist(i,j))
                continue;
            end
            
            
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
            
            
            
            %if ne(X_index,i) & ne(Y_index,j) & ne(X_index,j) & ne(Y_index,i)
            if eq(X_index,i) | eq(Y_index,i)
                if algorithm_type=="average"
                    NEW_DIST(new_index_x,new_index_y)=mean([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                elseif algorithm_type=="min"
                    NEW_DIST(new_index_x,new_index_y)=min([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                elseif algorithm_type=="max"
                    NEW_DIST(new_index_x,new_index_y)=max([Dist(j,X_index),Dist(j,Y_index),Dist(X_index,j),Dist(Y_index,j)]);
                end
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
    
    NEW_DIST=tril(NEW_DIST,-1)'+NEW_DIST;
    ALL_Tables{end+1}=NEW_DIST;
    Dist=NEW_DIST;
    NEW_DIST=zeros(size(Dist,1)-1,size(Dist,1)-1);
end

for n = 1:numel(ALL_Tables)
    table(ALL_Tables{n})
end



