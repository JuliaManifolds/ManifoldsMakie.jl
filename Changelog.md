# Changelog

All notable Changes to the Julia package `ManifoldMakie.jl` are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
'1q
## [0.1.0] unreleased

Initial release.

## Added

* a `sphereplot(Manifolds.Sphere(2))` to start a plot with a sphere to put points on.
* a `hyperboloidplot(Hyperbolic(n))` for `n=2,3` to start a plot in the hyperboloid model.
* a `poincareballplot(Hyperbolic(n))` t for `n=2,3` o start a plot in the Poincaré disc or ball model.
* a `poincarehalfspaceplot(Hyperbolic(n))` for `n=2,3` to start a plot in the Poincaré hal plane or half space model.