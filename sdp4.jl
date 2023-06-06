using DynamicPolynomials
using JuMP
using MosekTools
using MultivariatePolynomials

include("basis4.jl")
include("poly_operation.jl")

nv = length(vec(x))
nbasis = Vector{Vector{poly_data}}(undef, length(basis))
for i = 1:length(basis)
    nbasis[i] = polys_info(basis[i], vec(x))
end
ncons = polys_info(cons, vec(x))

model = Model(optimizer_with_attributes(Mosek.Optimizer))
f = poly_data(nv, [UInt16[]], [AffExpr(0)])
mul = [poly_data(nv, [UInt16[]], [AffExpr(0)]) for i=1:length(cons)]
for i = 1:length(basis)
    pos = @variable(model, [1:length(basis[i]), 1:length(basis[i])], PSD)
    for j = 1:length(basis[i]), k = j:length(basis[i])
        temp = poly_multi(nbasis[i][j], nbasis[i][k])
        if j == k
            temp.coe *= pos[j,k]   
        else
            temp.coe *= 2*pos[j,k]
        end
        poly_add!(f, temp)
    end
    for j = 1:length(cons)
        free = @variable(model, [1:length(basis[i])])
        for k = 1:length(basis[i])
            temp = poly_data(nv, nbasis[i][k].supp, nbasis[i][k].coe)
            temp.coe *= free[k]
            poly_add!(mul[j], temp)
        end
    end
end
for j = 1:length(cons)
    poly_add!(f, poly_multi(mul[j], ncons[j]))
end
g = poly_data(nv, [UInt16[]], [AffExpr(0)])
for i = 1:d, j = 1:n-1
    var = Int[]
    for k1 = 1:d, k2 = 1:n-1, k3 = 1:d, k4 = 1:2
        if i == k1 && j == k2
            push!(var, ncbfind(vec(x), nv, x[k1,k2,k3,k4]))
        end
    end
    temp = poly_data(nv, f.supp, f.coe)
    for k = 1:length(f.supp)
        if isodd(sum(count(f.supp[k].==y) for y in var))
            temp.coe[k] = -f.coe[k]
        end
    end
    if g.supp == [[]]
        poly_add!(g, temp)
    else
        poly_add!(g, temp, CommonSupp=true)
    end
end
var = Int[]
for k1 = 1:d, k2 = 1:n-1, k3 = 1:d
    push!(var, ncbfind(vec(x), nv, x[k1,k2,k3,2]))
end
temp = poly_data(nv, f.supp, f.coe)
for k = 1:length(f.supp)
    if isodd(sum(count(f.supp[k].==y) for y in var))
        temp.coe[k] = -f.coe[k]
    end
end
poly_add!(g, temp, CommonSupp=true)
@time begin
S4 = permutation([1;1;1;1])
for item in S4
    var = zeros(Int, nv)
    for k1 = 1:d, k2 = 1:n-1, k3 = 1:d, k4 = 1:2
        w = ncbfind(vec(x), nv, x[k1,k2,k3,k4])
        var[w] = ncbfind(vec(x), nv, x[k1,k2,item[k3],k4])
    end
    temp = poly_data(nv, f.supp, f.coe)
    temp.supp = [sort(var[f.supp[k]]) for k=1:length(f.supp)]
    poly_add!(g, poly_sort(temp), CommonSupp=true)
end
end
@constraint(model, g.coe .== 0)
@objective(model, Min, 0)
optimize!(model)
status = termination_status(model)
if status != MOI.OPTIMAL
    println("termination status: $status")
    status = primal_status(model)
    println("solution status: $status")
end
