"""
    poincareballbplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{2}}}; kwargs...)
    poincareballbplot(M::Hyperbolic{ManifoldsBase.TypeParameter{Tuple{3}}}; kwargs...)

Draw the [`Hyperbolic`](@extref `Manifolds.Hyperbolic`)`(n)`, `n` either `2` or `3`, in the [Poiuncaré disc model](https://en.wikipedia.org/wiki/Poincaré_disk_model),
which more generally is a ball for more than the 2D case.
This can be combined with
* [`scatter`](@extref `Makie.scatter`)`(M, pts)` to plot points thereon
* [`arrows3d`](@extref `Makie.arrows3d`)`(M, pts, vecs)` to plot tangent vectors
* [`geodesics`](@ref)`(M, pst)` and [`scattergeodesics`](@ref)`(M, pst)` to draw geodesics

## Example

```julia
fig, ax, p = poincareballbplot(Hyperbolic(2))
```
"""
@recipe PoincareBallPlot (M,) begin
    "Color of the wireframe lines drawn on top of the surface (only 3D)."
    wirecolor = (:lightsteelblue, 0.4)
    "Tessellation resolution (segments of the wireframe in every direction, only 3D)."
    wires = 24
    "linewidth of the wire (only 3D case)"
    wirewidth = 0.5
    "Solid color of the surface (3D) or boundary (2D)"
    surfacecolor = :black
    "Surface alpha (0 = transparent, 1 = opaque)."
    surfacealpha = 0.2
    "thickness of the boundary surface (only 2D)"
    surfaceboundary = 2
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

# 2D case: Poincare disc: We draw a boundary in surfacecolor – using a circle
function Makie.plot!(p::PoincareBallPlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}}})
    map!(p.attributes, [:M], :circle) do M
        return GeometryBasics.Circle(Point2f(0, 0), 1.0f0)
    end
    lines!(p, p.circle; color = p.surfacecolor, alpha = p.surfacealpha, linewidth = p.surfaceboundary)
    return p
end
# 3D case: Poincare ball: we draw a sphere in which all data will lie, so it should be very transparent
function Makie.plot!(p::PoincareBallPlot{<:Tuple{Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}}})
    # create a new compute edge
    # with [:M, :wires] as input nodes (these must already exist)
    # with :sphere_mesh as the output node (this will be created)
    # running the computation defined in the do ... end block
    # where :M is M and :wires is mapped to n
    map!(p.attributes, [:M, :wires], :sphere_mesh) do M, n
        return GeometryBasics.uv_normal_mesh(Tessellation(Makie.Sphere(Point3f(0), 1.0f0), n))
    end
    # A solid surface
    mesh!(
        p, p.sphere_mesh;
        color = p.surfacecolor, alpha = p.surfacealpha, transparency = true,
    )
    # a wireframe atop
    wireframe!(p, p.sphere_mesh; color = p.wirecolor, linewidth = p.wirewidth, transparency = true)
    return p
end

#
#
# Overwrite poincareballplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function poincareballplot(
        M::Hyperbolic{Manifolds.TypeParameter{Tuple{2}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false,
        aspect = Makie.DataAspect(), kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis(fig[1, 1])
    ax.aspect = aspect
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    pl = poincareballplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end
#
#
# Overwrite hyperboloidplot (as a bit of a hack) to remove axes and use the nice default sphere from the docs?
function poincareballplot(
        M::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}};
        size = (1024, 1024), backgroundcolor = :white, show_axis = false, aspect = :data, kwargs...
    )
    fig = Figure(; backgroundcolor = backgroundcolor, size = size)
    ax = Axis3(fig[1, 1], aspect = aspect)
    if !show_axis
        hidedecorations!(ax)
        hidespines!(ax)
    end
    ax.azimuth = π / 4
    pl = poincareballplot!(ax, M; kwargs...)
    return Makie.FigureAxisPlot(fig, ax, pl)
end

function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::V) where {V <: AbstractVector{<:PoincareBallPoint}}
    return Makie.convert_arguments(P, [Point2f(p.value) for p in pts])
end
# If we already get `<:Point` this is already defined in hyperboloid

function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{2}}}, pts::AbstractVector{<:PoincareBallPoint}, vecs::AbstractVector{<:PoincareBallTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [Point2f(p.value) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [Point2f(v.value) for v in vecs])[1],
    )
end
# If we already get `<:Point` and `<:Vecs` this is already defined in hyperboloid

function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}, pts::V) where {V <: AbstractVector{<:PoincareBallPoint}}
    return Makie.convert_arguments(P, [Point3f(p.value) for p in pts])
end
# If we already get `<:Point` this is already defined in hyperboloid

function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Hyperbolic{Manifolds.TypeParameter{Tuple{3}}}, pts::AbstractVector{<:PoincareBallPoint}, vecs::AbstractVector{<:PoincareBallTangentVector})
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), [Point3f(p.value) for p in pts])[1],
        convert_arguments(Makie.PointBased(), [Point3f(v.value) for v in vecs])[1],
    )
end
# If we already get `<:Point` and `<:Vecs` this is already defined in hyperboloid
