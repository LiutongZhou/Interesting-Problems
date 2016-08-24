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
A=ones(1,n);A=kron(eye(r+1),sparse(A));
b=X*ones(1,r+1);%inequality constraint A*S<=b as shown in constraint 1
%con2 is a function that sets equality constraint as shown in constraint 2
list=find(index>1);% construct a list of row_index of S which corresponds to the delayed row_index-th task by R
for i=list
    m=sum(index(i)-1);
end
sub=zeros(m,2);z=length(list);j=1;
for i=1:z
    sub(j:j+index(list(i))-1-1,2)=1:index(list(i))-1;
    sub(j:j+index(list(i))-1-1,1)=list(i);
    j=j+index(list(i))-1;
end% sub 存储了 constraint 2 中S的下标
j=sub2ind(size(S0), sub(:,1), sub(:,2));
Aeq=sparse(1:m,j,ones(m,1),m,n*(r+1));
beq=sparse(m,1);
[S,~,deltaT]=fminimax(maxgoal,S0,A,b',Aeq,beq,lb,ub);
TotalTime=sum([dt,deltaT]);
end
