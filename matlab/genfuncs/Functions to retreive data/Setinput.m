function [legendsn, al, ar, t, fs, delay] = Setinput(file,distance,duration,fileidx,j)
                                
                                %j is the idx no of the signal in file list

sn=(duration(fileidx(j)));      %duration entry for the title
sl=(sn+450)*48;                 %signal length
legendsn=num2str(sn);           %number of samples in file with length = duration + 450 ms
                                                                        
[a, fs]=audioread(file{fileidx(j)});
al=a(:,1);                      %left ear signal
ar=a(:,1);   % a(:,2)                   %right ear signal
al=al(1:sl);ar=ar(1:sl);        %fixing length of file to duration + 450 ms


t=1/fs*(0:length(a)-1);
t=t(1:sl);

delay = 2*distance(fileidx(j))/34400; %calculating theoretical reflection