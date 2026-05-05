# Plotting data on the 2D Sphere

```@example
using Manifolds, WGLMakie, ManifoldsMakie
M = Manifolds.Sphere(2)
fig = Figure(backgroundcolor = :white, size = (640, 500))
ax = LScene(fig[1, 1], show_axis = false)

sphereplot!(ax, M;
    surfacecolor = :white, surfacealpha = 0.2,
    wirecolor = (:lightsteelblue, 0.7), wires = 28, wirewidth = .5
)
p = [0.0, 0.0, 1.0]
q = [0.0, 1/sqrt(2), -1/sqrt(2)]
pts = Point3f.(geodesic(M, p, q, 0:0.1:1.0))

scatter!(ax, M, pts; color = :green, markersize = 8)
fig
```

## Function reference

```@docs
ManifoldsMakie.sphereplot
```