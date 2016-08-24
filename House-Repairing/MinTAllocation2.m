function [S,TotalTime]= MinTAllocation2(X,D,M,R)
%%  output the minimum time to finish all the task TotalTime and the corresponding allocation matrix S
% Input parameters: X is total labor, D is a demand row vector,
% M is a labor capacity constarint row vector, R is a ready row vector.
% Output Parameters: [S,TotalTime]

[u,~,index]=unique([R,0]);index(end)=[];
dt=diff(u);%ÿһ���׶εĹ�ʱ
n=length(D);r=length(dt);
S=zeros(n,r+1);D=D';M=M';
for i=1:r
    ind=D>0&index<=i;%ind Ϊ���Զ����������������
    S(ind,i)=D(ind)/sum(D(ind))*X;
    ind2=S(:,i)>M;%�������ֵ�����
    while any(ind2)&&any(ind&S(:,i)<M)%���г���M�ҿ��԰ѳ������ֽ��е��ȵ�δ��������
    residual=sum(S(ind2,i)-M(ind2));%ʣ���Ͷ���
    S(ind2,i)=M(ind2);%���ó�����������capacityԼ��
    ind3=ind&S(:,i)<M;% ���Զ�������Աδ�����ֵ�����
    S(ind3,i)=S(ind3,i)+D(ind3)/sum(D(ind3))*residual;%ʣ���������䵽��Աδ������
    ind2=S(:,i)>M;%�������ֵ�����
    end
    %���г������֣��������������������������ã�ʹ����MԼ��
    S(ind2,i)=M(ind2);
    D=D-S(:,i)*dt(i);
    D(D<0)=0;
end
S(:,r+1)=D/sum(D)*X;%��������M
S(S(:,r+1)>M,r+1)=M(S(:,r+1)>M); %������M
deltaT=max(D./S(:,r+1));
TotalTime=sum([dt,deltaT]);
end