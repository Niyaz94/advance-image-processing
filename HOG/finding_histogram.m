clear all;


histr  =zeros(1,9);
direction= 8;
index_rem = rem(direction,20);
index_val= fix(direction/20);
magnitude=130;

if index_rem<10  
    neiber_index=index_val;
    if index_val == 0
        neiber_index=9;
    end
    histr(index_val+1)=(magnitude*(direction-((index_val-1)*20+10))/20);
    histr(neiber_index)=magnitude*((index_val*20+10)-direction)/20;
else
    neiber_index=index_val+2;
    if index_val == 8
        neiber_index=1;
    end
    histr(index_val+1)=magnitude *(((index_val+1)*20+10)-direction)/20;
    histr(neiber_index)=magnitude*(direction-(index_val*20+10))/20;
end
