"""
    hyperboloidplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{2}}}; kwargs...)

Draw the [`Hyperbolic`](@extref `Manifolds.Hyperbolic`)`(2)` in the [hyperboloid](https://en.wikipedia.org/wiki/Hyperboloid#Hyperboloid_of_two_sheets) model as a (transparent) surface with an overlaid wireframe.
This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

## Example

```julia
fig, ax, p = hyperboloidplot(Hyperbolic(2))
```
"""
@recipe HyperboloidPlot (M,) begin
    "Color of the wireframe lines drawn on top of the surface."
    wirecolor = (:lightsteelblue, 0.4)
    "Tessellation resolution (segments of the wireframe in every direction)."
    wires = 24
    "linewidth of the wire"
    wirewidth = 0.5
    "Solid color of the surface."
    surfacecolor = :white
    "Surface alpha (0 = transparent, 1 = opaque)."
    surfacealpha = 0.5
    "range for the x-dimension for the surface"
    xlims = [-3, 3]
    "range for the y-dimension for the surface"
    ylims = [-3, 3]
    "refinement of points from wires to sampling the surface"
    refinement = 5
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

function Makie.plot!(p::HyperboloidPlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}}})
    # create a new compute edge – since we have to be careful with
    # maybe not yet initialized values
    # in: xlims, refinement, wires,  out: xwire xsurface
    map!(p.attributes, [:xlims, :refinement, :wires], [:xwire, :xsurface]) do xlims, refinement, wires
        return range(; start = xlims[1], stop = xlims[2], length = wires), range(; start = xlims[1], stop = xlims[2], length = refinement * wires)
    end
    # in: ylims, refinement, wires,  out: ywire ysurface
    map!(p.attributes, [:ylims, :refinement, :wires], [:ywire, :ysurface]) do ylims, refinement, wires
        return range(; start = ylims[1], stop = ylims[2], length = wires), range(; start = ylims[1], stop = ylims[2], length = refinement * wires)
    end
    # in: xwire, ywire, out: zwire
    map!(p.attributes, [:xwire, :ywire], :zwire) do x, y
        return [sqrt(1 + X^2 + Y^2) for X in x, Y in y]
    end
    # in: xsurface, ysurface, out: zsurface
    map!(p.attributes, [:xsurface, :ysurface], :zsurface) do x, y
        return [sqrt(1 + X^2 + Y^2) for X in x, Y in y]
    end
    # in: surfacecolor, out: surfacecolormap (constant)
    map!(p.attributes, :surfacecolor, :surfacecolormap) do sfc
        return [sfc]
    end    # with [:M, :wires] as input nodes (these must already exist)
    # with :sphere_mesh as the output node (this will be created)
    # running the computation defined in the do ... end block
    # where :M is M and :wires is mapped to n
    surface!(
        p, p.xsurface, p.ysurface, p.zsurface;
        colormap = p.surfacecolormap, alpha = p.surfacealpha, transparency = true,
    )
    # a wireframe atop
    wireframe!(
        p, p.xwire, p.ywire, p.zwire;
        color = p.wirecolor, linewidth = p.wirewidth, transparency = true
    )
    return p
end

#
#
# Overwrite hyperboloidplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function hyperboloidplot(
        M::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, kwargs...
    )
    fig = Figure(backgroundcolor = backgroundcolor, size = size)
    ax = LScene(fig[1, 1], show_axis = show_axis)
    pl = hyperboloidplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:AbstractVector}}
    return Makie.convert_arguments(P, Point3f.(pts))
end
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:HyperboloidPoint}}
    return Makie.convert_arguments(P, [Point3f(p.value) for p in pts])
end
# If we already have points, all is fine.
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:Point}}
    return Makie.convert_arguments(P, pts)
end


# For arrows3d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W) where {V <: AbstractVector{<:AbstractVector}, W <: AbstractVector{<:AbstractVector}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), Point3f.(pts))[1],
        convert_arguments(Makie.PointBased(), Point3f.(vecs))[1],
    )
end
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::AbstractVector{<:HyperboloidPoint}, vecs::AbstractVector{<:HyperboloidTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [Point3f(p.value) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [Point3f(v.value) for v in vecs])[1],
    )
end
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V, vecs::W) where {V <: AbstractVector{<:Point}, W <: AbstractVector{<:Vec}}
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1],
        convert_arguments(Makie.PointBased(), vecs)[1],
    )
end
