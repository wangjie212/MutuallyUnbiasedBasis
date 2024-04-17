using DynamicPolynomials
using JuMP
using MosekTools
using MultivariatePolynomials

include("basis4.jl")
include("poly_operation.jl")

tsupp = ninvbas4
ltsupp = length(tsupp)
model = Model(optimizer_with_attributes(Mosek.Optimizer))
cons = [AffExpr(0) for i=1:ltsupp]
for i = 1:length(basis)
    pos = @variable(model, [1:length(basis[i]), 1:length(basis[i])], PSD)
    for j = 1:length(basis[i]), k = j:length(basis[i])
        @inbounds temp = poly_norm(poly_multi(nbasis[i][j], nbasis[i][k]), n, d, group)
        for l = 1:length(temp.supp)
            @inbounds ind = bfind(tsupp, ltsupp, temp.supp[l])
            if j == k
                @inbounds add_to_expression!(cons[ind], temp.coe[l], pos[j,k]) 
            else
                @inbounds add_to_expression!(cons[ind], 2*temp.coe[l], pos[j,k]) 
            end
        end
    end
end
for k = 1:d, i = 1:n-1, l = 1:d
    if k == l
        h = sum(x[k,i,q,1]*x[l,i,q,1]+x[k,i,q,2]*x[l,i,q,2] for q = 1:d) - 1
        bas = ninvbas2
    else
        h = sum(x[k,i,q,1]*x[l,i,q,1]+x[k,i,q,2]*x[l,i,q,2] for q = 1:d)
        bas = generate_bas1(i, k, l, x, d)
    end
    nh = polys_info([h], vec(x))[1]
    free = @variable(model, [1:length(bas)])
    for p = 1:length(bas), q = 1:length(nh.supp)
        @inbounds ind = bfind(tsupp, ltsupp, normalform([bas[p]; nh.supp[q]], n, d, group))
        @inbounds add_to_expression!(cons[ind], nh.coe[q], free[p]) 
    end
    h = sum(x[k,i,q,1]*x[l,i,q,2]-x[l,i,q,1]*x[k,i,q,2] for q = 1:d)
    nh = polys_info([h], vec(x))[1]
    bas = generate_bas2(i, k, l, x, d)
    free = @variable(model, [1:length(bas)])
    for p = 1:length(bas), q = 1:length(nh.supp)
        @inbounds ind = bfind(tsupp, ltsupp, normalform([bas[p]; nh.supp[q]], n, d, group))
        @inbounds add_to_expression!(cons[ind], nh.coe[q], free[p]) 
    end
    h = x[k,i,l,1]^2 + x[k,i,l,2]^2 - 1/d
    nh = polys_info([h], vec(x))[1]
    free = @variable(model, [1:length(ninvbas2)])
    for p = 1:length(ninvbas2), q = 1:length(nh.supp)
        @inbounds ind = bfind(tsupp, ltsupp, normalform([ninvbas2[p]; nh.supp[q]], n, d, group))
        @inbounds add_to_expression!(cons[ind], nh.coe[q], free[p]) 
    end
end
@constraint(model, cons .== 0)
@objective(model, Min, 0)
optimize!(model)
status = termination_status(model)
println("termination status: $status")
