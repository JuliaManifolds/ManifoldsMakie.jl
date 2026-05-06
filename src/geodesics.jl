"""
    geodesics(M, points)

Creates a connected geodesic plot connecting all or `points` sequentially.

`NaN` values are displayed as gaps in the line.
"""
@recipe Geodesics (M, points) begin
    Makie.documented_attributes(Lines)...
    "Set the number of samples used per geodesic"
    samples = 100
end

function Makie.plot!(p::Geodesics{<:Tuple{AM, V}}) where {AM <: Manifolds.AbstractManifold, V}
    # accessing input variables and properties seems a bit tricky here?!
    # This idea is taken from the docs of Makie.Computed
    M = p[:M][]
    points = p[:points][]
    n = length(points)
    s = p[:samples][]
    @info "s = " s
    for i in 1:(n - 1)
        p1 = points[i]
        p2 = points[i]
        pts = shortest_geodesic(M, p1, p2, range(; start = 0.0, stop = 1.0, length = n))
        lines!(p, p.attributes, M, pts)
    end
    return p
end
