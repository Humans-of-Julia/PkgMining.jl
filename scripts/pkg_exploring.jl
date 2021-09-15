# This is just a playground file

include("../src/PkgMining.jl")

using DataFrames
using .PkgMining

df = pkg_mining()

df[df.owner .== "JuliaImages", :name]

df[df.name .== "DifferentialEquations", :owner]

df[occursin.("holy", df.owner), :].name

gd = groupby(df, :owner)

owners = Dict(first(g.owner) => nrow(g) for g in gd)
owners = [first(g.owner) => nrow(g) for g in gd]

# Ratio of owners with 10 or more packages:
length(filter(x -> last(x) ≥ 10, owners))/length(owners)

sort!(owners, by = x -> last(x), rev = true)

[nrow(df[df.owner .== owner, :]) for owner in df.owner]

# Create DataFrame with owner and the number of packages they own
df_owned = combine(groupby(df, :owner), nrow => :pkgs_owned)

# Copy and extend the packages DataFrame to contain column with the number of packages
# owned by the onwer of that package
df_copy = copy(df)

transform(groupby(df_copy, :owner), :owner => length => :pkgs_owned)

# Check total number of packages
@info sum(unique(df, :owner).pkgs_owned) == size(df, 1)