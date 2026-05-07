# Visualizing Geodesics

In [`Makie`](https://makie.org/) there exist [`lines`](@extref `Makie.lines`)
and [`scatterlines`](@extref `Makie.scatterlines`). On manifolds a line segment is generalised to “the shortest curve with zero intrinsic acceleration”, or [`shortest_geodesic`](@extref `ManifoldsBase.shortest_geodesic-Tuple{AbstractManifold, Any, Any}`). Similarly here we introduce `geodesics(M, points)` to generate a piecewise (shortest) geodesics curve and `scattergeodesics(M, points)` when the points should also be marked.

```@docs
geodesics
scattergeodesics
```
