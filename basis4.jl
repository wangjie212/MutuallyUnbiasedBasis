d = 4
n = 2
@polyvar x[1:d,1:n-1,1:d,1:2]
basis = Vector{Vector{Polynomial{true, Int64}}}(undef, 79)
basis[1] = [1; vec([x[i,j,1,1]^2+x[i,j,2,1]^2 for i = 1:d, j = 1:n-1]); vec([x[i,j,1,2]^2+x[i,j,2,2]^2 for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]^2+x[i,j,4,1]^2 for i = 1:d, j = 1:n-1]); vec([x[i,j,3,2]^2+x[i,j,4,2]^2 for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,2,1] for i = 1:d, j = 1:n-1]); vec([x[i,j,1,2]*x[i,j,2,2] for i = 1:d, j = 1:n-1]); 
vec([x[i,j,3,1]*x[i,j,4,1] for i = 1:d, j = 1:n-1]); vec([x[i,j,3,2]*x[i,j,4,2] for i = 1:d, j = 1:n-1]); 
vec([x[i,j,1,1]*x[i,j,3,1]+x[i,j,1,1]*x[i,j,4,1]+x[i,j,2,1]*x[i,j,3,1]+x[i,j,2,1]*x[i,j,4,1] for i = 1:d, j = 1:n-1]); 
vec([x[i,j,1,2]*x[i,j,3,2]+x[i,j,1,2]*x[i,j,4,2]+x[i,j,2,2]*x[i,j,3,2]+x[i,j,2,2]*x[i,j,4,2] for i = 1:d, j = 1:n-1])]

basis[2] = [vec([x[i,j,1,1]*x[i,j,3,1]-x[i,j,1,1]*x[i,j,4,1]+x[i,j,2,1]*x[i,j,3,1]-x[i,j,2,1]*x[i,j,4,1] for i = 1:d, j = 1:n-1]); 
vec([x[i,j,1,2]*x[i,j,3,2]-x[i,j,1,2]*x[i,j,4,2]+x[i,j,2,2]*x[i,j,3,2]-x[i,j,2,2]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]^2-x[i,j,4,1]^2 for i = 1:d, j = 1:n-1]); vec([x[i,j,3,2]^2-x[i,j,4,2]^2 for i = 1:d, j = 1:n-1])]

basis[3] = [vec([x[i,j,1,1]*x[i,j,3,1]-x[i,j,1,1]*x[i,j,4,1]-x[i,j,2,1]*x[i,j,3,1]+x[i,j,2,1]*x[i,j,4,1] for i = 1:d, j = 1:n-1]); 
vec([x[i,j,1,2]*x[i,j,3,2]-x[i,j,1,2]*x[i,j,4,2]-x[i,j,2,2]*x[i,j,3,2]+x[i,j,2,2]*x[i,j,4,2] for i = 1:d, j = 1:n-1])]

basis[4] = [vec([x[i,j,1,1]*x[i,j,1,2]+x[i,j,2,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,2,2]+x[i,j,2,1]*x[i,j,1,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,3,2]+x[i,j,4,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,4,2]+x[i,j,4,1]*x[i,j,3,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,3,2]+x[i,j,1,1]*x[i,j,4,2]+x[i,j,2,1]*x[i,j,3,2]+x[i,j,2,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,1,2]+x[i,j,3,1]*x[i,j,2,2]+x[i,j,4,1]*x[i,j,1,2]+x[i,j,4,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1])]

basis[5] = [vec([x[i,j,1,1]*x[i,j,1,2]-x[i,j,2,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,2,2]-x[i,j,2,1]*x[i,j,1,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,3,2]+x[i,j,1,1]*x[i,j,4,2]-x[i,j,2,1]*x[i,j,3,2]-x[i,j,2,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,1,2]-x[i,j,3,1]*x[i,j,2,2]+x[i,j,4,1]*x[i,j,1,2]-x[i,j,4,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1])]

basis[6] = [vec([x[i,j,3,1]*x[i,j,3,2]-x[i,j,4,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,4,2]-x[i,j,4,1]*x[i,j,3,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,1,1]*x[i,j,3,2]+x[i,j,1,1]*x[i,j,4,2]+x[i,j,2,1]*x[i,j,3,2]-x[i,j,2,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,1,2]+x[i,j,3,1]*x[i,j,2,2]-x[i,j,4,1]*x[i,j,1,2]-x[i,j,4,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1])]

basis[7] = [vec([x[i,j,1,1]*x[i,j,3,2]-x[i,j,1,1]*x[i,j,4,2]-x[i,j,2,1]*x[i,j,3,2]+x[i,j,2,1]*x[i,j,4,2] for i = 1:d, j = 1:n-1]);
vec([x[i,j,3,1]*x[i,j,1,2]-x[i,j,3,1]*x[i,j,2,2]-x[i,j,4,1]*x[i,j,1,2]-x[i,j,4,1]*x[i,j,2,2] for i = 1:d, j = 1:n-1])]

k = 8
for i = 1:d, j = 1:n-1
    basis[k] = [x[i,j,1,1]+x[i,j,2,1]; x[i,j,3,1]+x[i,j,4,1]]
    basis[k+1] = [x[i,j,1,1]-x[i,j,2,1]]
    basis[k+2] = [x[i,j,3,1]-x[i,j,4,1]]
    k += 3
end

for i = 1:d, j = 1:n-1
    basis[k] = [x[i,j,1,2]+x[i,j,2,2]; x[i,j,3,2]+x[i,j,4,2]]
    basis[k+1] = [x[i,j,1,2]-x[i,j,2,2]]
    basis[k+2] = [x[i,j,3,2]-x[i,j,4,2]]
    k += 3
end

for i1 = 1:d, i2 = 1:d, j1 = 1:n-1, j2 = 1:n-1
    if [i1, j1] > [i2, j2]
        basis[k] = [[x[i1,j1,1,l]*x[i2,j2,1,l]+x[i1,j1,2,l]*x[i2,j2,2,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,2,l]+x[i1,j1,2,l]*x[i2,j2,1,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,3,l]+x[i1,j1,4,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,4,l]+x[i1,j1,4,l]*x[i2,j2,3,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,l]+x[i1,j1,1,l]*x[i2,j2,4,l]+x[i1,j1,2,l]*x[i2,j2,3,l]+x[i1,j1,2,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,l]+x[i1,j1,3,l]*x[i2,j2,2,l]+x[i1,j1,4,l]*x[i2,j2,1,l]+x[i1,j1,4,l]*x[i2,j2,2,l] for l=1:2]]
        basis[k+1] = [[x[i1,j1,1,l]*x[i2,j2,1,l]-x[i1,j1,2,l]*x[i2,j2,2,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,2,l]-x[i1,j1,2,l]*x[i2,j2,1,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,l]+x[i1,j1,1,l]*x[i2,j2,4,l]-x[i1,j1,2,l]*x[i2,j2,3,l]-x[i1,j1,2,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,l]-x[i1,j1,3,l]*x[i2,j2,2,l]+x[i1,j1,4,l]*x[i2,j2,1,l]-x[i1,j1,4,l]*x[i2,j2,2,l] for l=1:2]]
        basis[k+2] = [[x[i1,j1,3,l]*x[i2,j2,3,l]-x[i1,j1,4,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,4,l]-x[i1,j1,4,l]*x[i2,j2,3,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,l]-x[i1,j1,1,l]*x[i2,j2,4,l]+x[i1,j1,2,l]*x[i2,j2,3,l]-x[i1,j1,2,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,l]+x[i1,j1,3,l]*x[i2,j2,2,l]-x[i1,j1,4,l]*x[i2,j2,1,l]-x[i1,j1,4,l]*x[i2,j2,2,l] for l=1:2]]
        basis[k+3] = [[x[i1,j1,1,l]*x[i2,j2,3,l]-x[i1,j1,1,l]*x[i2,j2,4,l]-x[i1,j1,2,l]*x[i2,j2,3,l]+x[i1,j1,2,l]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,l]-x[i1,j1,3,l]*x[i2,j2,2,l]-x[i1,j1,4,l]*x[i2,j2,1,l]+x[i1,j1,4,l]*x[i2,j2,2,l] for l=1:2]]
        k += 4
    end
end

for i1 = 1:d, i2 = 1:d, j1 = 1:n-1, j2 = 1:n-1
    if [i1, j1] > [i2, j2]
        basis[k] = [[x[i1,j1,1,l]*x[i2,j2,1,mod(l,2)+1]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,2,mod(l,2)+1]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,1,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,3,mod(l,2)+1]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,4,mod(l,2)+1]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,3,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,mod(l,2)+1]+x[i1,j1,1,mod(l,2)+1]*x[i2,j2,4,l]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,3,l]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,mod(l,2)+1]+x[i1,j1,3,mod(l,2)+1]*x[i2,j2,2,l]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,1,l]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2]]
        basis[k+1] = [[x[i1,j1,1,l]*x[i2,j2,1,mod(l,2)+1]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,2,mod(l,2)+1]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,1,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,mod(l,2)+1]+x[i1,j1,1,mod(l,2)+1]*x[i2,j2,4,l]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,3,l]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,mod(l,2)+1]-x[i1,j1,3,mod(l,2)+1]*x[i2,j2,2,l]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,1,l]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2]]
        basis[k+2] = [[x[i1,j1,3,l]*x[i2,j2,3,mod(l,2)+1]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,4,mod(l,2)+1]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,3,l] for l=1:2];
        [x[i1,j1,1,l]*x[i2,j2,3,mod(l,2)+1]-x[i1,j1,1,mod(l,2)+1]*x[i2,j2,4,l]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,3,l]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,mod(l,2)+1]+x[i1,j1,3,mod(l,2)+1]*x[i2,j2,2,l]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,1,l]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2]]
        basis[k+3] = [[x[i1,j1,1,l]*x[i2,j2,3,mod(l,2)+1]-x[i1,j1,1,mod(l,2)+1]*x[i2,j2,4,l]-x[i1,j1,2,mod(l,2)+1]*x[i2,j2,3,l]+x[i1,j1,2,mod(l,2)+1]*x[i2,j2,4,l] for l=1:2];
        [x[i1,j1,3,l]*x[i2,j2,1,mod(l,2)+1]-x[i1,j1,3,mod(l,2)+1]*x[i2,j2,2,l]-x[i1,j1,4,mod(l,2)+1]*x[i2,j2,1,l]+x[i1,j1,4,mod(l,2)+1]*x[i2,j2,2,l] for l=1:2]]
        k += 4
    end
end

nbasis = [polys_info(item, vec(x)) for item in basis]
