function dH = hausdorff( A, B) 
%A=A(A>=0);
%B=B(B>=0);
if (sum(A,'all')*sum(B,'all')>0)
    dH = max(compute_pdist(A, B), compute_pdist(B, A));
else
    dH = inf;
end
end
% Compute pdistance
function dist = compute_pdist(A, B) 
szA = size(A);
szB = size(B);
d_vec = [];
%D = [];
% dim= size(A, 2); 
%for j = 1:m(2)
iA=find(A);
iB=find(B);
bb=1;
for k = iB'    
    %for k= 1: n(2)
    aa=1;
    D = [];
    for j = iA'
        [rowA,colA,slA] = ind2sub(szA,j);
        [rowB,colB,slB] = ind2sub(szB,k);
        D(aa)=norm([rowA,colA,slA]-[rowB,colB,slB]);
        %D(k) = abs((A(j)-B(k)));
        aa=aa+1;
    end
    
    d_vec(bb) = min(D);
    bb=1+1;
end
% keyboard
 dist = max(d_vec);
end