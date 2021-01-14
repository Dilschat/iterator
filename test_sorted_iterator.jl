using Test
using BenchmarkTools

include("sorted_iterator.jl")

function sort_test(iter::SortedVectors)
    result = []
    next = iterate(iter)
    while next !== nothing
        append!(result, next[3])
        next = iterate(iter, next[4])
    end
    return result
end


@testset "sorted iterator of sorted data" begin
    @test sort_test(SortedVectors([[1,2,3],[3,4]])) == [1,2,3,3,4]
    @test sort_test(SortedVectors([[1,2,3,5],[3,4],[4,10]])) == [1, 2, 3, 3, 4, 4, 5, 10]
    @test sort_test(SortedVectors([[1,2,3,5],[0,3,4],[4,10]])) == [0, 1, 2, 3, 3, 4, 4, 5, 10]
    @test sort_test(SortedVectors([[1,1,1],[1,1]])) == [1,1,1,1,1]
    @btime iterate(SortedVectors([[1],[0]]), Vector{Union{Int64, Nothing}}([1,1]))
end

@testset "sorted iterator of empty data" begin
    @test isnothing(iterate(SortedVectors([[],[]])))
    @test isnothing(iterate(SortedVectors([])))
end
