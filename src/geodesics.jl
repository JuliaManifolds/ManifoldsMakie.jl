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
    # Iterate through the positions
    @info V
    # These do not work?
    @info p[1]
    @info p[2]
    # These do not work?
    @info p.M
    @info p.points
    n = length(p.points)
    s = p.samples
    for i in 1:(n - 1)
        p1 = p.points[i]
        p2 = p.points[i]
        pts = shortest_geodesic(p.M, p1, p2, range(; start = 0.0, stop = 1.0, length = n))
        lines!(p, p.attributes, p.M, pts)
    end
    return p
end
