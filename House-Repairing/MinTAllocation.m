function [S,TotalTime]=MinTAllocation(X,D,M,R)
%%  output the minimum time to finish all the task TotalTime and the corresponding allocation matrix S
% Input parameters: X is total labor, D is a demand row vector,
% M is a labor capacity constarint row vector, R is a ready row vector.
% Output Parameters: [S,TotalTime]
[u,~,index]=unique([R,0]);
dt=diff(u);
maxgoal=@(S) (D'-S(:,1:end-1)*dt')./S(:,end);
n=length(D);r=length(dt);
S0=ones(n,r+1);%the start point of S
lb=zeros(size(S0));%lower bound of S
ub=repmat(M',1,r+1);%upper bound of S as shown in constraint 1
A=ones(1,n);A=kron(eye(r+1),A);%inequality constraint A*S<=b as shown in constraint 1
b=X*ones(r+1,1);%inequality constraint A*S<=b as shown in constraint 1
list=find(index>1);% construct a list of row_index of S which corresponds to the delayed row_index-th task by R
% so that S(i,1:index-1) must equal to zero
for i=list
    m=sum(index(i)-1);%m is total number of linear inequality constraints described in constraint 2
end
sub=zeros(m,2);z=length(list);j=1;% 初始化下标索引sub用于存储constraint 2 中S的下标，
%sub(：,1)，sub(:,2)对应constraint 2 中所有S(i,j) 的下标(i,j)
for i=1:z % sub 存储了 constraint 2 中S的下标 
    sub(j:j+index(list(i))-1-1,2)=1:index(list(i))-1;
    sub(j:j+index(list(i))-1-1,1)=list(i);%list(i) is the row number of S that needs to be set constraint 2
    j=j+index(list(i))-1;
end
j=sub2ind(size(S0), sub(:,1), sub(:,2));%下标转化为线性索引
Aeq=sparse(1:m,j,ones(m,1),m,n*(r+1));%构建线性等式约束constriant 2 中的Aeq
beq=sparse(m,1);
[S,~,deltaT]=fminimax(maxgoal,S0,A,b,Aeq,beq,lb,ub);%用优化求解器求解模型
TotalTime=sum([dt,deltaT]);%输出结果
end