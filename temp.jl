using Manifolds, GLMakie, ManifoldsMakie

M = Manifolds.Sphere(2)
p1 = [0.0, 0.0, 1.0]
p2 = [0.0, 1.0, 0.0]
p3 = [1.0, 0.0, 0.0]
pts = Point3f.([p1, p2, p3])

fig = Figure(backgroundcolor = :white, size = (900, 900))
ax = LScene(fig[1, 1], show_axis = false)

sphereplot!(
    ax, M;
    surfacecolor = :white, surfacealpha = 0.3,
    wirecolor = (:lightsteelblue, 0.4), wires = 28, wirewidth = 0.5
)
geodesics!(ax, M, pts; color = :green)
