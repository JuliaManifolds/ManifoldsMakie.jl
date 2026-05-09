# Welcome to ManifoldMakie

This repository defines [Makie.jl](https://makie.org/) [Recipes](https://docs.makie.org/stable/explanations/recipes`).
to plot manifold-valued data for certain manifolds from [Manifolds.jl](https://juliamanifolds.github.io/Manifolds.jl/stable/)

## Motivation

When working with data on manifolds and the manifold admits a nice visualisation, that
can be beneficial to interpret results.

Sometime such a visialusation leads to boiler plate code, e.g. so set up the environment
or to convert points, tangent vectors, geodesics, or other elements to plot.

## Design choices

While [Makie.jl](https://makie.org/) always works on `Point2` or `Point3` geometry basic types,
this package aims to lower the access for plotting methods. It converts data defined on manifolds
to geometry data when necessary.

In general any method made available here always requires the manifold to be specified.
On the one hand the manifold might be needed internal, on the other hand, this avoids
type piracy and unwanted interactions.
For example given some [`Axis`](@extref `Makie.Axis`) `ax` to plot into, a , a manifold `M`
and some points thereon. Calling

```
scatter(ax, M, pts)
```

accepts the points `pts` as
* a vector of `AbstractArrays` if the manifold has a default representation in simple arrays,
for example (unit) vectors of length 3 for the [`Sphere`](@extref `Manifolds.Sphere`)
* a vector of [`AbstractManifoldPoint`](@extref `ManifoldsBase.AbstractManifoldPoint`)s to specify the representation of points chosen on the manifold,
for example whether to use [`HyperboloidPoint`](@extref `Manifolds.HyperboloidPoint`)s or [`PoincareBallPoint`](@extref `Manifolds.PoincareBallPoint`)
to specify the visualization chosen, where the last point would be the same as the hyperbolic case.
* a vector of `Point2` or `Point3` types when you already did the conversion yourself. Since then different representations can not be distinguished, this is only useful for the default representations the same way as the first case is. This last conversion should happen within this package basically only when “passing” over to actual methods implemented in [Makie.jl](https://makie.org/) itself.
