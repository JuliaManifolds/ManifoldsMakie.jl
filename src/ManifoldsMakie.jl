module ManifoldsMakie

using GeometryBasics
using Manifolds
using Manifolds: Sphere
using Makie
import Makie: scatter, scatter!

include("sphere.jl")

export Sphere
export scatter, scatter!
end # module ManifoldsMakie
