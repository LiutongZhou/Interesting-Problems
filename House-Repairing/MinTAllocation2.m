function [S,TotalTime]= MinTAllocation2(X,D,M,R)
%%  output the minimum time to finish all the task TotalTime and the corresponding allocation matrix S
% Input parameters: X is total labor, D is a demand row vector,
% M is a labor capacity constarint row vector, R is a ready row vector.
% Output Parameters: [S,TotalTime]
[u,~,index]=unique([R,0]);index(end)=[];%u 和index 同解题思路中的解释一样
dt=diff(u);%每一个阶段的工时
n=length(D);r=length(dt);
S=zeros(n,r+1);D=D';M=M';%初始化人力分配矩阵S
for i=1:r%对于前r个有预热的阶段
    ind=D>0&index<=i;%ind 为可以动工的子任务的索引
    S(ind,i)=D(ind)/sum(D(ind))*X;%把labor按比例分配到可以动工的任务中去
    ind2=S(:,i)>M;%人力分配超出capacity约束部分的索引
    while any(ind2)&&any(ind&S(:,i)<M)%若有超出M的人力且存在人手未满的任务
    residual=sum(S(ind2,i)-M(ind2));%剩余劳动力
    S(ind2,i)=M(ind2);%重置超出部分满足capacity约束
    ind3=ind&S(:,i)<M;%ind3为 可以动工的人员未满部分的索引
    S(ind3,i)=S(ind3,i)+D(ind3)/sum(D(ind3))*residual;%剩余劳力分配到人员未满部分
    ind2=S(:,i)>M;%更新超出capacity部分的索引
    end%迭代至所有任务不超出capacity或者有超出 但所有任务人手已满，则分配结束
    S(ind2,i)=M(ind2);    %若有超出部分，但所有任务人手已满，则重置，使满足M约束
    D=D-S(:,i)*dt(i);%进行做工
    D(D<0)=0;
end
S(:,r+1)=D/sum(D)*X;%若不超过M
S(S(:,r+1)>M,r+1)=M(S(:,r+1)>M); %若超过M
deltaT=max(D./S(:,r+1));%计算最后一个阶段的最小用时
TotalTime=sum([dt,deltaT]);%计算总项目用时
end