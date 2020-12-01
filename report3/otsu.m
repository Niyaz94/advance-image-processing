clear();
values = [8 7 2 6 9 4];
between_class =zeros(1,length(values));
Values_TOTAL=sum(values);% total of all elements

for i=1:length(values)
    shreshold_value=i;
    % define background and foreground oundary
    background_value=[1,shreshold_value-1];
    foreground_value=[shreshold_value,length(values)];
    % calculating background
    background_weight=0;
    background_mean=0;
    % calculating upper part of equation
    for x=background_value(1):background_value(2)
         background_weight=background_weight+values(x);
         background_mean=background_mean+((x-1)*values(x));
    end
    background_weight=background_weight/Values_TOTAL;
    background_mean=background_mean/sum(values(background_value(1):background_value(2)));
    % calculating foreground
    foreground_weight=0;
    foreground_mean=0;
    % calculating upper part of equation
    for y=foreground_value(1):foreground_value(2)
         foreground_weight=foreground_weight+values(y);
         foreground_mean=foreground_mean+((y-1)*values(y));
    end
    foreground_weight=foreground_weight/Values_TOTAL;
    foreground_mean=foreground_mean/sum(values(foreground_value(1):foreground_value(2)));
    %Wb*Wf*(μb-μf)^2
    between_class(i)=foreground_weight*background_weight*power((background_mean-foreground_mean),2);
end
% convert NAN to zero
between_class(isnan(between_class))=0;


fprintf('K = %d with the value equal to %f \n',(find(between_class==max(between_class))-1),max(between_class))