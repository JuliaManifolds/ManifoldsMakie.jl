"""
    sphereplot(::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}; kwargs...)

Draw the [`Sphere`](@extref `Manifolds.Sphere`)`(2)` as a (transparent) surface with an overlaid wireframe.
Combine with [`scatter`](@extref Makie.scatter) to plot points or paths on it.

```julia
fig, ax, p = sphereplot(Manifolds.Sphere(2))
scatter!(ax, Manifolds.Sphere(2), pts)
```
"""
@recipe SpherePlot (M,) begin
    "Color of the wireframe lines drawn on top of the surface."
    wirecolor = :gray40
    "Tessellation resolution (segments of the wireframe in every direction)."
    wires = 32
    "linewidth of the wire"
    wirewidth = 1
    "Solid color of the surface."
    surfacecolor = :blue
    "Surface alpha (0 = transparent, 1 = opaque)."
    surfacealpha = 0.5
    # add the other default plot attributes here as well
    Makie.mixin_generic_plot_attributes()...
end

function Makie.plot!(plot::SpherePlot{<:Tuple{Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}}})
    # create a new compute edge
    # with [:M, :wires] as input nodes (these must already exist)
    # with :sphere_mesh as the output node (this will be created)
    # running the computation defined in the do ... end block
    # where :M is M and :wires is mapped to n
    map!(plot.attributes, [:M, :wires], :sphere_mesh) do M, n
        return GeometryBasics.uv_normal_mesh(Tessellation(Makie.Sphere(Point3f(0), 1.0f0), n))
    end
    # A solid surface
    mesh!(
        plot, plot.sphere_mesh;
        color = plot.surfacecolor,
        alpha = plot.surfacealpha,
        transparency = true,
    )
    # a wireframe atop
    wireframe!(plot, plot.sphere_mesh; color = plot.wirecolor, linewidth = plot.wirewidth, transparency = true)
    return plot
end

# For `scatter(M, pts)`, `lines(M, pts)`, `scatterlines(M, pts)`
# (and any other PointBased plot) work on a manifold via this overload.
# We do not have to transform the points
function Makie.convert_arguments(P::Makie.PointBased, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts)
    return Makie.convert_arguments(P, pts)
end

# For arrows3d(M, pts, vecs) we want to combine the classical scatter with arrows,
# where we assume that vecs[i] is in the tangent space of pts[1]
function Makie.convert_arguments(::Makie.ArrowLike, ::Manifolds.Sphere{ℝ, Manifolds.TypeParameter{Tuple{2}}}, pts, vecs)
    #Not 100 % sure why the [1] is necessary, taken from conversions happening in arrows.jlr
    return (
        convert_arguments(Makie.PointBased(), pts)[1],
        convert_arguments(Makie.PointBased(), vecs)[1],
    )
end

# For lines(M, pts), we want to intercept and use separate lines of sampled geodesics between the points
#
#
