% Demo of sounds used in projekt on echolocation (Schenkman & Nilsson)

clear
clc
zzz = input('Ange följande som en vektor: [distans, duration, rum, storlek]     ');
[file room size distance duration repetition] = textread('file_list.txt', '%s%n%n%n%n%n');

fs = 48000; %sampling frequency
isi = 0.4; %inter-stimulus-interval in seconds

for i = 1:3
  v_set = find(duration == zzz(2) & distance == zzz(1) & room == zzz(3) & size == zzz(4));
  a = randperm(length(v_set));
  vrow = v_set(a(1));
  vv = wavread(file{vrow});
  sl = (a(2)+450)*48; %number of samples in file with length = duration + 450 ms
  v = vv(1:sl); %fixing length of file to duration + 450 ms
  k = repetition(vrow); %finding repetition number of variable
            
 
  s_set = find(duration == zzz(2) & distance == 0 & size == 0 & room == zzz(3) & repetition == k); %finding set of s-sounds with same repetition number as v
  b = randperm(length(s_set));
  srow = s_set(b(1));
  ss = wavread(file{srow});
  s = ss(1:sl); %fixing length of file to duration + 450 ms
  g = [0,1];
  r = randperm(2);
                    if g(r(1)) == 0 %deciding if variable before standard or vice verca
                        wavplay(v, fs);
                        pause(isi)
                        wavplay(s, fs);
                        pc = 1;
                        order = 'vs';
                    else
                        wavplay(s, fs);
                        pause(isi)
                        wavplay(v, fs);
                        pc = 0;
                        order = 'sv';
                    end
               
              
                question = sprintf('\n\n\n\n\n\tVar objektet närvarande i ljud 1 (Tryck 1)     eller ljud 2 (Tryck 0)?     ');
                resp = input(question, 's');
               
             %handling error responses
                allowed = ['1'; '0'];
                while isempty(resp) | ~ismember(resp,allowed) | length(resp) > 1
                 errormessage = sprintf('\n\n\n\t Fel tangent, försök igen!         ');
                 resp = input(errormessage, 's');
                end
                resp = str2num(resp);
             %feedback
                    if pc == resp
                        disp('Rätt')
                    else
                        disp('Fel')
                    end
   pause(0.75)                       
end