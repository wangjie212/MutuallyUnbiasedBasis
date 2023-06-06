using SparseArrays

mutable struct poly_data
    n::Int
    supp::Vector{Vector{UInt16}}
    coe
end

function permutation(a)
    b = sparse(a)
    ua = convert(Vector{UInt16}, b.nzind)
    na = convert(Vector{UInt16}, b.nzval)
    return _permutation(ua, na)
end

function _permutation(ua, na)
    if !isempty(ua)
        perm = Vector{UInt16}[]
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
        return [UInt16[]]
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
    return 0
end

function poly_add!(p, q; CommonSupp=false)
    if CommonSupp == false
        for i = 1:length(q.supp)
            ind,flag = findloc(p.supp, length(p.supp), q.supp[i])
            if flag == 1
                v = p.coe[ind] + q.coe[i]
                if v != 0
                    p.coe[ind] = v
                else
                    deleteat!(p.supp, ind)
                    deleteat!(p.coe, ind)
                end
            else
                insert!(p.supp, ind, q.supp[i])
                insert!(p.coe, ind, q.coe[i])
            end
        end
    else
        p.coe += q.coe
    end
    return p
end

function poly_multi(p, q)
    s = poly_data(max(p.n, q.n), [UInt16[]], [eltype(p.coe)(0)])
    for i = 1:length(q.supp)
        supp = [sort([p.supp[j]; q.supp[i]]) for j=1:length(p.supp)]
        coe = p.coe*q.coe[i]
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
        supp = [UInt16[] for j=1:length(mon)]
        for j = 1:length(mon)
            ind = mon[j].z .> 0
            vars = mon[j].vars[ind]
            exp = mon[j].z[ind]
            for k in eachindex(vars)
                l = ncbfind(x, n, vars[k])
                append!(supp[j], l*ones(UInt16, exp[k]))
            end
        end
        poly[i] = poly_data(n, supp, coe)
    end
    return poly
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
    return 0
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

function poly_sort(p)
    supp = sort(p.supp)
    coe = zeros(eltype(p.coe), length(supp))
    for i = 1:length(supp)
        ind = bfind(supp, length(supp), p.supp[i])
        coe[ind] = p.coe[i]
    end
    return poly_data(p.n, supp, coe)
end