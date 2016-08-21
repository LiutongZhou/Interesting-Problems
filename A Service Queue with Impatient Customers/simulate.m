function n=simulate(lambda,mu,t)
% parameters initialization
%  generating inter-arriving times Xi
j=round(t/(1/lambda));
X=exprnd(1/lambda,[1,j]);
while sum(X)<=t
    j=j+1;
    X(j)=exprnd(1/lambda);
end
while sum(X)>t
    X(j)=[];
    j=j-1;
end
% service times for j customers who arrived in t hours 
Y=exprnd(1/mu,[1,j]);
T=zeros(1,j);Z=zeros(1,j);W=zeros(1,j+1);% a trick used here: let W(1) stands for W(0), thus the i-th customer leaves at W(i+1)
W(1)=0;
for i=1:j % for the i-th customer
    T(i)=sum(X(1:i)); %the arriving time of the i-th customer
    r=nnz(W(1:i)>T(i));% # of people in front of the i-th customer when he arrives
    if r==0
        pr=0;
    else 
        pr=(1-1/r);
    end
    if binornd(1,pr)==1 %if the i-th customer leaves immediately
        W(i+1)=T(i); %leaving time      
    else %if the i-th customer stays in line
        Z(i)=max([T(i),W(1:i)]); % he reaches the head of the line at Z(i)
        W(i+1)=Y(i)+Z(i);
    end
end
n=nnz(W>t);
end