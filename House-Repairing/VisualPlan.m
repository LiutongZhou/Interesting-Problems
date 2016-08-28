function VisualPlan(X,D,M,R)
[S,T]=MinTAllocation2(X,D,M,R);
[n,~]=size(S);
u=unique([R,0]);
dt=diff(u);
figure;ax1=axes('YDir','reverse','YTick',1:n);
hold on;yticklabels=cell(1,n);
annotation('textbox',[0.15 0.92 0 0],'String',['Total time: ',num2str(T,'%.2f'),' days'],'FitBoxToText','on','FontSize',8,'EdgeColor','w','Margin',0);
for  i=1:n
    list=find(S(i,:)>0);%u(list(end)) is the start time point of the last time interval
    preinterval=1:list(end)-1;
    residual=D(i)-sum(S(i,preinterval).*dt(preinterval));
    DeltaT=residual/S(i,list(end));%u(list(end))+DeltaT is the end point of the last time interval
    try         x=[u(list(1):list(end));... %u(list(1)) is the start time point of the first time interval
            u(list(2):list(end)),u(list(end))+DeltaT];
    catch
        x=[u(list(1):list(end));... %u(list(1)) is the start time point of the first time interval
            u(list(end))+DeltaT];
    end
    y=i*ones(size(x));
    plot(x,y,'LineWidth',8);
    text(mean(x),mean(y)+0.3,cellstr(num2str(S(i,list)','%.2f')),'HorizontalAlignment','center','FontSize',8);
    text(T/2,i-0.3,'workers','HorizontalAlignment','center','FontSize',8);
    yticklabels{i}=['Task ',num2str(i)];
end
ax1.YTickLabel=yticklabels;
box off;grid on;axis([0,T+1,0,i+1]);
title('Synchronous Allocation','FontSize',12);
xlabel('Time/days');
end