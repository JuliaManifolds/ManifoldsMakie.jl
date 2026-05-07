"""
    geodesics(M, points)

Creates a connected geodesic plot connecting all or `points` sequentially.

`NaN` values are displayed as gaps in the line.
"""
@recipe Geodesics (M, points) begin
    Makie.documented_attributes(Lines)...
    "Set the number of samples used per geodesic"
    samples = 100
    "Set the curve to be closed by connecting the last and first point as well"
    closed = false
end

function Makie.plot!(p::Geodesics{<:Tuple{AM, V}}) where {AM <: Manifolds.AbstractManifold, V}
    # accessing input variables and properties seems a bit tricky here?!
    # This idea is taken from the docs of Makie.Computed
    M = p[:M][]
    points = p[:points][]
    n = length(points)
    s = p[:samples][]
    for i in 1:(n - 1)
        p1 = points[i]
        p2 = points[i + 1]
        pts = shortest_geodesic(M, p1, p2, range(; start = 0.0, stop = 1.0, length = s))
        lines!(p, p.attributes, M, Point3f.(pts))
    end
    if p[:closed][]
        p1 = points[end]
        p2 = points[1]
        pts = shortest_geodesic(M, p1, p2, range(; start = 0.0, stop = 1.0, length = s))
        lines!(p, p.attributes, M, Point3f.(pts))
    end
    return p
end

"""
    scattergeodesics(M, points)

Plots a `scatter` of points on a manifold `M` and `geodesics` between them.
This plot recipe follows [`scatterlines`](@extref `Makie.scatterlines`) very closely.
"""
@recipe ScatterGeodesics (M, points) begin
    Makie.documented_attributes(Geodesics)...
    Makie.filtered_attributes(
        Scatter, exclude = (
            :color, :colormap, :colorrange, :colorscale, :lowclip, :highclip, :alpha,
            :nan_color,
            :fxaa, :visible, :transparency, :space, :clip_planes, :ssao, :overdraw,
            :cycle, :transformation, :model, :depth_shift,
            :inspector_clear, :inspector_hover, :inspector_label, :inspectable,
        )
    )...
    "The color of the line, and by default also of the scatter markers."
    color = @inherit linecolor
    "Sets the color of scatter markers. These default to `color`"
    markercolor = Makie.automatic
    "Sets the colormap for scatter markers. This defaults to `colormap`"
    markercolormap = Makie.automatic
    "Sets the colorrange for scatter markers. This defaults to `colorrange`"
    markercolorrange = Makie.automatic
end

function Makie.plot!(p::ScatterGeodesics{<:Tuple{AM, V}}) where {AM <: Manifolds.AbstractManifold, V}
    #
    #
    # The following implementation is nearly identical with ScatterLines, just that

    # markercolor is the same as linecolor if left automatic
    map!(p, [:color, :markercolor], :real_markercolor) do color, markercolor
        return to_color(markercolor === Makie.automatic ? color : markercolor)
    end

    map!(p, [:colormap, :markercolormap], :real_markercolormap) do colormap, markercolormap
        return markercolormap === Makie.automatic ? colormap : markercolormap
    end

    map!(p, [:colorrange, :markercolorrange], :real_markercolorrange) do colorrange, markercolorrange
        return markercolorrange === Makie.automatic ? colorrange : markercolorrange
    end

    geodesics!(p, p.attributes, p.M, p.points)
    scatter!(
        p, p.attributes, p.M, p.points;
        color = p.real_markercolor,
        colormap = p.real_markercolormap,
        colorrange = p.real_markercolorrange,
    )
    return p
end
