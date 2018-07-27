clc;
clear all;
close all;
%%
% figure;
LoudnessThd5ms=[3.4 4.1; 3.2 4.7];
[p,tbl,stats]=anova2(LoudnessThd5ms);
%multcompare(stats);
%%
% figure;
LoudnessThd50ms=[3.6 5;4.3 8];
[p,tbl,stats]=anova2(LoudnessThd50ms);
%%
% figure;
LoudnessThd500ms=[4.8 5.1;1.1 2.8];
[p,tbl,stats]=anova2(LoudnessThd500ms);


LoudnessThdallms = [LoudnessThd5ms(1,:); LoudnessThd50ms(1,:); LoudnessThd500ms(1,:); ...
    LoudnessThd5ms(2,:);  LoudnessThd50ms(2,:);LoudnessThd500ms(2,:)];

[p,tbl,stats]=anova2(LoudnessThdallms,3);