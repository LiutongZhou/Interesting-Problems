%% An Evacuation Traffic Management Problem Modeled in Integer Programming
%% Import Data
clear;
opts=detectImportOptions('Data.xlsx','Sheet','Traffic Link');
linkdata=readtable('Data.xlsx',opts);
opts=detectImportOptions('Data.xlsx','Sheet','Traffic Node');
nodedata=readtable('Data.xlsx',opts);
%% Construct Traffic Network (Bi-directional Graph)
EdgeTable=table;NodeTable=table;
EdgeTable.EndNodes = str2num(char(linkdata.Link))+1;
EdgeTable.Link_Name=strcat('l_',replace(linkdata.Link,',','_'));
NodeTable.Name=cellstr(num2str(nodedata.Node));
G = digraph(EdgeTable,NodeTable);
%% output IncidenceMatrix to excel
xlswrite('Data.xlsx',incidence(G),'Incidence Matrix');
xlswrite('Data.xlsx',G.Edges.Link_Name,'Traffic Link','D2');
%% Solve Integer Programming Model In Lingo
opts=detectImportOptions('Data.xlsx','Sheet','Traffic Link');
linkdata=readtable('Data.xlsx',opts);
opts=detectImportOptions('Data.xlsx','Sheet','Traffic Node');
nodedata=readtable('Data.xlsx',opts);
EdgeTable=table;NodeTable=table;
EdgeTable.EndNodes = str2num(char(linkdata.Link))+1;
EdgeTable.Weight=linkdata.flow;
NodeTable.Name=cellstr(num2str(nodedata.Node));
G = digraph(EdgeTable,NodeTable);
LWidths = 5*(G.Edges.Weight+eps)/max(G.Edges.Weight);
figure('Position',[0,0,800,400])
h=plot(G,'ArrowSize',13,'NodeColor','r','EdgeLabel',G.Edges.Weight,'LineWidth',LWidths,'EdgeCData',-G.Edges.Weight,'EdgeAlpha',1)
colormap bone
axis([-3,3,-1.6,1.5]);axis off;