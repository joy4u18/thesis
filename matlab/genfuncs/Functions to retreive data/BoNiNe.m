function [file,  distance, noclicks, repetition, fileidx, plotcolor, objectlegend ] = BoNiNe(ncl,rp)


[file, distance, noclicks, repetition]=textread('list.txt','%s%n%n%n');                                                            % Loading the  recordings.

fileidx=find((distance==50 | distance==100 | distance==150 | distance==0)  & noclicks==ncl & repetition==rp);                      % Selction of room,duration & size.
                  
plotcolor={'b--','k','k','k'};                                               % Color properties

objectlegend={'No object','object at 50cm','object at 100cm','object at 150cm'...
    'OBJECT PEAKS'};                                                          % Object entry for legend


                                                          


   