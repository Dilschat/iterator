using Pipe

struct SortedVectors
    data::Vector{Vector{Int}}
end

SortedVectorsIterState = Vector{Union{Int64,Nothing}}

"""
Initializes iterator over sorted vectors

# Arguments
- `vectors::SortedVectors`: vector sorted in ascending order
"""
Base.iterate(vectors::SortedVectors) =
    iterate(vectors, SortedVectorsIterState(ones(length(vectors.data))))

function Base.iterate(vectors::SortedVectors, state::SortedVectorsIterState)
    element, data_idx = @pipe zip(state, vectors.data) |>
          map(_get_element_or_missing, _) |>
          skipmissing(_) |>
          _findmin(_)
    _get_next(element, data_idx, state)
end

_findmin(itr) = isempty(itr) ? (nothing, nothing) : findmin(itr)

_get_element_or_missing((idx, arr)::Tuple{Int,Int})::Union{Int,Missing} =
    get(arr, idx, missing)

_get_next(element::Int, data_idx::Int, state::SortedVectorsIterState) =
    (data_idx, state[data_idx], element, _get_next_state(data_idx, state))

_get_next(element::Nothing, data_idx::Nothing, state::SortedVectorsIterState) =
    nothing

function _get_next_state(data_idx::Int, state::SortedVectorsIterState)
    new_state = copy(state)
    new_state[data_idx] += 1
    return new_state
end
