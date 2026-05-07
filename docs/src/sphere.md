# Plotting data on the 2D Sphere

On a sphere we can plot points and tangent vectors with the default
[`scatter`](@extref `Makie.scatter`) and [`arrows3d`](@extref `Makie.arrows3d`).
To start a plot on a manifold, there is usually a `manifoldplot` function, here [`sphereplot`](@ref)
to set up the figure and add here for example the sphere the data lives on.

```@example
using Manifolds, ManifoldsMakie, GLMakie

M = Manifolds.Sphere(2)
fig, ax, pl = sphereplot(M)

p = [0.0, 0.0, 1.0]
q = [0.0, 1/sqrt(2), -1/sqrt(2)]
r = [1/sqrt(2), 0.0, 1/sqrt(2)]
P = shortest_geodesic(M, p, q, 0:0.05:1.0)
X = [log(M, s, r) for s in P]
pts = Point3f.(P)
vecs = Vec3f.(X)

scatter!(ax, M, pts; color = :green, markersize = 8)
scatter!(ax, M, [Point3f(r),]; color = :orange, markersize = 8)
arrows3d!(ax, M, pts, vecs; color = :blue,
    minshaftlength = 0, shaftlength=.99, shaftradius = 0.005,
    tipradius = 0.02, tiplength = 0.1)
fig
```

We can also use the [`geodesics`](@ref) and [`scattergeodesics`](@ref) functions here.

```@example
using Manifolds, ManifoldsMakie, GLMakie

M = Manifolds.Sphere(2)
fig, ax, pl = sphereplot(M)

p1, p2, p3 = [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]
p1b, p2b, = [1/sqrt(2), 0, 1/sqrt(2)], [0, 1/sqrt(2), 1/sqrt(2)]

geodesics!(ax, M, Point3f.([p1, p2, p3]); closed = true, color = :green, linewidth = 3)
scattergeodesics!(ax, M, Point3f.([p1b, p2b, p3]); closed = true, color = :blue, linewidth = 2, markersize = 12)
fig
```

## Function reference

```@docs
ManifoldsMakie.sphereplot
```