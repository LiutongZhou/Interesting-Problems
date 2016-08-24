function [S,TotalTime]=MinTAllocation(X,D,M,R)
%X=14; D=[160 20 10]; M=[20 2 20];R=[0 0 2];
[u,~,index]=unique([R,0]);
dt=diff(u);
maxgoal=@(S) (D'-S(:,1:end-1)*dt')./S(:,end);
n=length(D);r=length(dt);
S0=ones(n,r+1);%the start point of S
lb=zeros(size(S0));%lower bound of S
ub=repmat(M',1,r+1);%upper bound of S as shown in constraint 1
A=ones(1,n);A=repmat(A,r+1);
b=X*ones(1,r+1);%inequality constraint A*S<=b as shown in constraint 1
%con2 is a function that sets equality constraint as shown in constraint 2
[S,~,deltaT]=fminimax(maxgoal,S0,A,b',[],[],lb,ub,@(S)con2(S,index));
TotalTime=sum([dt,deltaT]);
end

function [c,ceq]=con2(S,index)
%% con2 is a function that sets equality constraint as shown in constraint 2
c=[];ceq=[];
j=0;
list=find( index>1);
n=length(list);
for i=1:n
    ceq(j+1:j+index(list(i))-1)=S(i,1:index(list(i))-1);
    j=j+index(list(i))-1;
end
end