using BenchmarkTools

function unique!(array::AbstractVector{T}, s::Integer, e::Integer) where {T}
    n = length(array)
    a = array
    b = similar(array)
    seg = 1
    while seg < n
        for start = 1:2seg:n
            mid = min(start + seg - 1, n)
            i, e1 = start, mid
            j, e2 = min(mid + 1, n), min(mid + seg, n)
            k = start
            while i <= e1 && j <= e2
                if a[i] == a[j]
                    b[k] = a[i]
                    i += 1
                    j += 1
                elseif a[i] < a[j]
                    b[k] = a[i]
                    i += 1
                else
                    b[k] = a[j]
                    j += 1
                end
                k += 1
            end
            foreach(x -> b[x[2]] = a[x[1]], zip(i:e1, k:n))
            foreach(x -> b[x[2]] = a[x[1]], zip(j:e2, k:n))
        end
        a, b = b, a
        seg += seg
    end
    (array === b) || (array .= b)
end


a = [1, 5, 2, 7, 6, 4, 3, 2, 1]
unique!(a, 1, length(a))

a = [1, 5, 2, 7, 6, 4, 3, 2, 1]
@benchmark unique!(a, 1, length(a))
