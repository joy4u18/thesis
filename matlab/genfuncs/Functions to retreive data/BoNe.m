function [file, room, distance, duration, repetition, fileidx, plotcolor, objectlegend, roomtitle, no] = BoNe(rm,du,rp,nobject)


[file, room, size, distance, duration, repetition]=textread('file_list.txt',...
'%s%n%n%n%n%n');                                                            % Loading the  recordings.

fileidx=find(room==rm & duration==du & repetition==rp & (size==50| size...
    ==0));                                                                  % Selction of room,duration & size.
                  
plotcolor={'b--','b--','k','k','k','k','k','k'};                            % Color properties

objectlegend={'No object','No object','object at 50cm','object at 100cm','object at 200cm',... 
    'object at 300cm','object at 400cm','object at 500cm','no object peaks',...
    'peaks'
};                                                        % Object entry for legend

roomtitle={'CONFERENCE ROOM,RECORDED WITH AND WITHOUT OBJECT','ANECHOIC ROOM,RECORDED WITH AND WITHOUT OBJECT'};                                        % Room entry for the title

if nobject==1
    no=1;
else
    no=2;
end

