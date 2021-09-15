# This is just a playground file

include("../src/PkgMining.jl")

using DataFrames
using .PkgMining

df = pkg_mining()

df[df.owner .== "SciML", :]

df[occursin.("holy", df.owner), :].name

gd = groupby(df, :owner)

owners = Dict(first(g.owner) => size(g, 1) for g in gd)
owners = [first(g.owner) => size(g, 1) for g in gd]

# Ratio of owners with 10 or more packages:
length(filter(x -> last(x) ≥ 10, owners))/length(owners)

sort!(owners, by = x -> last(x), rev = true)

[size(df[df.owner .== owner, :], 1) for owner in df.owner]

# Check total number of packages
@info sum(unique(df, :owner).pkgs_owned) == size(df, 1)