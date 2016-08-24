function [S,TotalTime]= MinTAllocation2(X,D,M,R)
%%  output the minimum time to finish all the task TotalTime and the corresponding allocation matrix S
% Input parameters: X is total labor, D is a demand row vector,
% M is a labor capacity constarint row vector, R is a ready row vector.
% Output Parameters: [S,TotalTime]

[u,~,index]=unique([R,0]);index(end)=[];
dt=diff(u);%每一个阶段的工时
n=length(D);r=length(dt);
S=zeros(n,r+1);D=D';M=M';
for i=1:r
    ind=D>0&index<=i;%ind 为可以动工的子任务的索引
    S(ind,i)=D(ind)/sum(D(ind))*X;
    ind2=S(:,i)>M;%超出部分的索引
    while any(ind2)&&any(ind&S(:,i)<M)%若有超出M且可以把超出部分进行调度到未超出部分
    residual=sum(S(ind2,i)-M(ind2));%剩余劳动力
    S(ind2,i)=M(ind2);%重置超出部分满足capacity约束
    ind3=ind&S(:,i)<M;% 可以动工的人员未满部分的索引
    S(ind3,i)=S(ind3,i)+D(ind3)/sum(D(ind3))*residual;%剩余劳力分配到人员未满部分
    ind2=S(:,i)>M;%超出部分的索引
    end
    %若有超出部分，但所有任务人手已满，则重置，使满足M约束
    S(ind2,i)=M(ind2);
    D=D-S(:,i)*dt(i);
    D(D<0)=0;
end
S(:,r+1)=D/sum(D)*X;%若不超过M
S(S(:,r+1)>M,r+1)=M(S(:,r+1)>M); %若超过M
deltaT=max(D./S(:,r+1));
TotalTime=sum([dt,deltaT]);
end