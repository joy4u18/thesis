function  [legendsn, a1, a2, a3, t, dt] = Setinput2(file,~,noclicks,idx,j,rp)
                                                                           %j is the idx no of the signal in file list

sn=(noclicks(idx(j)));                                                     %duration entry for the title
if rp== 1 
sll=160;
elseif  rp== 2 
sll=200;
elseif rp== 3 
sll=230;
elseif rp== 4 ||rp==  5 ||rp==  6 || rp== 7
sll=280;
elseif rp== 8 ||rp==  9 ||rp==  10
sll=300;                                                                    %signal length
end                                                                        %signal length
legendsn=num2str(sn);                                                      %number of samples in file with length = duration + 450 ms
                                                                         
load(file{idx(j)});
a1=al;                                                                     %left ear signal
a2=ar;                                                                     %right ear signal
a3=ee;
a1=a1(sll:end);a2=a2(sll:end);a3=a3(sll:end);                              %fixing length of file to duration + 450 ms

fs=44100;
dt=1/fs;
t=dt*(0:length(a1)-1);
