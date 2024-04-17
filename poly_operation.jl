using SparseArrays

mutable struct poly_data
    n::Int
    supp::Vector{Vector{UInt8}}
    coe
end

function permutation(a)
    b = sparse(a)
    ua = convert(Vector{UInt8}, b.nzind)
    na = convert(Vector{UInt8}, b.nzval)
    return _permutation(ua, na)
end

function _permutation(ua, na)
    if !isempty(ua)
        perm = Vector{UInt8}[]
        for i = 1:length(ua)
            nua = copy(ua)
            nna = copy(na)
            if na[i] == 1
                deleteat!(nua, i)
                deleteat!(nna, i)
            else
                nna[i] -= 1
            end
            temp = _permutation(nua, nna)
            push!.(temp, ua[i])
            append!(perm, temp)
        end
        return perm
    else
        return [UInt8[]]
    end
end

function bfind(A, l, a)
    low = 1
    high = l
    while low <= high
        mid = Int(ceil(1/2*(low+high)))
        if A[mid] == a
           return mid
        elseif A[mid] < a
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return nothing
end

function findloc(A, l, a)
    low = 1
    high = l
    while low <= high
        mid = Int(ceil(1/2*(low+high)))
        if A[mid] == a
           return mid,1
        elseif A[mid] < a
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return low,0
end

function poly_add!(p, q)
    for i = 1:length(q.supp)
        ind,flag = findloc(p.supp, length(p.supp), q.supp[i])
        if flag == 1
            @inbounds p.coe[ind] += q.coe[i]
        else
            @inbounds insert!(p.supp, ind, q.supp[i])
            @inbounds insert!(p.coe, ind, q.coe[i])
        end
    end
    return p
end

function poly_multi(p, q)
    s = poly_data(max(p.n, q.n), [UInt8[]], [eltype(p.coe)(0)])
    for i = 1:length(q.supp)
        @inbounds supp = [sort([p.supp[j]; q.supp[i]]) for j=1:length(p.supp)]
        @inbounds coe = p.coe*q.coe[i]
        poly_add!(s, poly_data(0, supp, coe))
    end
    return s
end

function polys_info(p, x)
    m = length(p)
    n = length(x)
    poly = Vector{poly_data}(undef, m)
    for i = 1:m
        mon = monomials(p[i])
        coe = coefficients(p[i])
        supp = [UInt8[] for j=1:length(mon)]
        for j = 1:length(mon)
            ind = mon[j].z .> 0
            vars = mon[j].vars[ind]
            exp = mon[j].z[ind]
            for k in eachindex(vars)
                l = ncbfind(x, n, vars[k])
                append!(supp[j], l*ones(UInt8, exp[k]))
            end
        end
        poly[i] = poly_data(n, supp, coe)
    end
    return poly
end

function monos_info(monos, x)
    n = length(x)
    m = length(monos)
    mons = [UInt8[] for i=1:m]
    for i = 1:m
        ind = monos[i].z .> 0
        vars = monos[i].vars[ind]
        exp = monos[i].z[ind]
        for k in eachindex(vars)
            l = ncbfind(x, n, vars[k])
            append!(mons[i], l*ones(UInt8, exp[k]))
        end
    end
    return mons
end

function ncbfind(A, l, a)
    low = 1
    high = l
    while low <= high
        mid = Int(ceil(1/2*(low+high)))
        if A[mid] == a
           return mid
        elseif A[mid] < a
            high = mid - 1
        else
            low = mid + 1
        end
    end
    return nothing
end

function poly_norm(p, n, d, group)
    nsupp = [normalform(item, n, d, group) for item in p.supp]
    supp = copy(nsupp)
    sort!(supp)
    unique!(supp)
    coe = zeros(eltype(p.coe), length(supp))
    for i = 1:length(supp)
        @inbounds ind = bfind(supp, length(supp), nsupp[i])
        @inbounds coe[ind] = p.coe[i]
    end
    return poly_data(p.n, supp, coe)
end

function normalform(a, n, d, group)    
    pa = Vector{Vector{UInt8}}(undef, length(group))
    ind = Vector{Vector{UInt8}}(undef, length(a))
    for k = 1:length(a)
        ind[k] = getind(n, d, a[k])
    end
    for i = 1:length(group)
        temp = deepcopy(ind)
        for k = 1:length(a)
            temp[k][3] = group[i][ind[k][3]]
        end
        pa[i] = sort([temp[k][1]+(temp[k][2]-1)*d+(temp[k][3]-1)*(n-1)*d+(temp[k][4]-1)*(n-1)*d^2 for k=1:length(a)])
    end
    return minimum(pa)
end

function getind(n, d, l)
    if l == 2*(n-1)*d^2
        return UInt8[d;n-1;d;2]
    end
    ind = ones(UInt8, 4)
    if l >= (n-1)*d^2
        ind[4] = 2
        l -= (n-1)*d^2
    end
    ind[3] = floor(Int, l/((n-1)*d)) + 1
    l -= (n-1)*d*(ind[3]-1)
    ind[2] = floor(Int, l/d) + 1
    ind[1] = l - d*(ind[2]-1)
    return ind
end

function generate_bas1(i, k, l, x, d)
    bas = Monomial{true}[]
    for s = 1:d, t = 1:d
        push!(bas, x[k,i,s,1]*x[l,i,t,1], x[k,i,s,2]*x[l,i,t,2])
    end
    return monos_info(bas, x)
end

function generate_bas2(i, k, l, x, d)
    bas = Monomial{true}[]
    for s = 1:d, t = 1:d
        push!(bas, x[k,i,s,1]*x[l,i,t,2], x[l,i,t,1]*x[k,i,s,2])
    end
    return monos_info(bas, x)
end

invbas2 = Monomial{true}[1]
for i = 1:d, j = 1:n-1, k = 1:d, l = k:d
    push!(invbas2, x[i,j,k,1]*x[i,j,l,1], x[i,j,k,2]*x[i,j,l,2])
end
ninvbas2 = monos_info(invbas2, x)
group = permutation(ones(d))
invbas4 = Monomial{true}[]
for i1 = 1:d, j1 = 1:n-1, i2 = 1:d, j2 = 1:n-1 
    if [i1; j1] == [i2; j2]
        for k1 = 1:d, k2 = k1:d, k3 = 1:d, k4 = k3:d
            if [k1; k2] <= [k3; k4]
                push!(invbas4, x[i1,j1,k1,1]*x[i1,j1,k2,1]*x[i2,j2,k3,1]*x[i2,j2,k4,1], x[i1,j1,k1,2]*x[i1,j1,k2,2]*x[i2,j2,k3,2]*x[i2,j2,k4,2])
            end
        end
        for k1 = 1:d, k2 = 1:d, k3 = 1:d, k4 = 1:d
            if [k1; k2] <= [k3; k4]
                push!(invbas4, x[i1,j1,k1,1]*x[i1,j1,k2,2]*x[i2,j2,k3,1]*x[i2,j2,k4,2])
            end
        end
    elseif [i1; j1] < [i2; j2]
        for k1 = 1:d, k2 = k1:d, k3 = 1:d, k4 = k3:d
            push!(invbas4, x[i1,j1,k1,1]*x[i1,j1,k2,1]*x[i2,j2,k3,1]*x[i2,j2,k4,1], x[i1,j1,k1,2]*x[i1,j1,k2,2]*x[i2,j2,k3,2]*x[i2,j2,k4,2])
        end
        for k1 = 1:d, k2 = 1:d, k3 = 1:d, k4 = 1:d
            push!(invbas4, x[i1,j1,k1,1]*x[i1,j1,k2,2]*x[i2,j2,k3,1]*x[i2,j2,k4,2])
        end
    end
    for k1 = 1:d, k2 = k1:d, k3 = 1:d, k4 = k3:d
        push!(invbas4, x[i1,j1,k1,1]*x[i1,j1,k2,1]*x[i2,j2,k3,2]*x[i2,j2,k4,2])
    end
end
invbas4 = [ninvbas2; monos_info(invbas4, x)]
ninvbas4 = [normalform(item, n, d, group) for item in invbas4]
sort!(ninvbas4)
unique!(ninvbas4)