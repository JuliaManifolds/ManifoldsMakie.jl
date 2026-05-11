# Plotting Hyperbolic data

## The 2D Hyperboloid

For the hyperboloid model, points and tangent vectors are either represented by plain arrays
or using the [`HyperboloidPoint](@extref `Manifolds.HyperboloidPoint`) and the [`HyperboloidTangentVector](@extref `Manifolds.HyperboloidTangentVector`). Here we illustrate both: For a scatter plot, we use arrays first

```@example
using GLMakie, ManifoldMakie, Manifolds
M = Hyperbolic(2)
fig, ax, pl = hyperboloidplot(M)
p = [2.0, 0.0, sqrt(5)]
q = [2.0, 2.0, 3.0]
r = [2.0, -2.0, 3.0]
pts = [p, q, r]
vecs = [log(M, p, q), log(M, q, p), log(M, r, p)]

scatter!(ax, M, pts, markersize = 20, color=:green)
arrows3d!(
    ax, M, pts, vecs; color = :blue,
    minshaftlength = 0, shaftlength=.99, shaftradius = 0.004,
    tipradius = 0.016, tiplength = 0.1,
)
update_cam!(ax.scene, Vec3d([7.0, 0.0, 1.0]), Vec3d([0.0,0.0,1.0]))
fig
```

And for the (generic) plot of geodesics between points we illustrate this with the typed points

```@example
using GLMakie, ManifoldMakie, Manifolds
M = Hyperbolic(2)
fig, ax, pl = hyperboloidplot(M)

pts = HyperboloidPoint.([[2.0, 2.0, 3.0], [2.0, -2.0, 3.0], [1.5, 0.0, sqrt(3.25)]])
geodesics!(ax, M, pts; linewidth = 2, color = :blue)
pts = HyperboloidPoint.([[2.0, 2.0, 3.0], [2.0, -2.0, 3.0], [2.5, 0.0, sqrt(7.25)]])
scattergeodesics!(ax, M, pts; linewidth = 3, color = :green, markersize = 16, closed = true)
update_cam!(ax.scene, Vec3d([7.0, 0.0, 1.0]), Vec3d([0.0,0.0,1.0]))
fig
```
## The Poincaré Halfplane for 2D and 3D hyperbolic data

## The Poincaré disk and ball

For the [Poincaré disc]() we can even plot 2D and 3D hyperbolic data.

### 2D Hyperbolic data on the Poincaré disc

```@example
using GLMakie, ManifoldMakie, Manifolds
M = Hyperbolic(2)
fig, ax, pl = poincareballplot(M; surfacealpha = 0.5, surfaceboundary = 1)

pts = PoincareBallPoint.([[0.0, 0.0], [0.7, -0.7], [0.7, 0.7], [-0.7, 0.7], [-0.7, -0.7]])
vecs = [
    0.25 * log(M, pts[1], pts[2]), [log(M, p, pts[1]) for p in pts[2:end]]...,
]
scatter!(ax, M, pts; color = :blue, markersize = 8)
arrows2d!(ax, M, pts, vecs; color = :green)
geodesics!(ax, M, pts[2:end]; closed=true, color = :orange)
fig
```

### 3D Hyperbolic data and the Poincaré ball

```@example
using GLMakie, ManifoldMakie, Manifolds
M = Hyperbolic(3)
fig, ax, pl = poincareballplot(M; surfacealpha = 0.0, )
pts = PoincareBallPoint.([[0.0, 0.0, 0.0], [0.5, 0.5, 0.5], [-0.5, 0.5, 0.5], [-0.5, -0.5, 0.5], [-0.5, -0.5, -0.5], [-0.5, 0.5, -0.5], [0.5, 0.5, -0.5]])
vecs = [
    0.25 .* log(M, pts[1], pts[2]), [log(M, p, pts[1]) for p in pts[2:end]]...
]
scatter!(ax, M, pts; color = :blue, markersize = 8)
arrows3d!(ax, M, pts, vecs; color = :green)
geodesics!(ax, M, pts[2:end]; closed=true, color = :orange)
update_cam!(ax.scene, Vec3d([3.0, -1.5, 1.0]), Vec3d([0.0,0.0,0.0]))
fig
```

## Function reference

```@docs
ManifoldMakie.hyperboloidplot
ManifoldMakie.poincareballplot
```