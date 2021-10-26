function Evv = get_fas(C,v)
% Computes fiber aligned strain
% expects strain tensor matrix C and vector matrix v for all voxels
% see Ennis paper equation 7

% reshape for matrix multiplication
C = reshape(C,256*256,3,3);
C = permute(C,[2 3 1]);

v = reshape(v,256*256,3,1);
v = permute(v,[2 3 1]);

% align strain C in direction of vector v
Cv = pagemtimes(C,v);
Evv = sum(v .* Cv); %dot product
Evv = reshape(Evv,256,256);

end