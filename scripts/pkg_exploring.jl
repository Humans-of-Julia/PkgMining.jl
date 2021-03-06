# This is just a playground file

using DataFrames
using PkgMining

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
df_owners = combine(groupby(df, :owner), nrow => :pkgs_owned)

# Copy and/or extend the packages DataFrame to contain column with the number of packages
# owned by the onwer of that package
df_owners2 = combine(groupby(df, :owner), :owner, :owner => length => :pkgs_owned)
df_owners3 = copy(df)
transform(groupby(df_owners3, :owner), :owner => length => :pkgs_owned)

# Check total number of packages
@info sum(df_owners.pkgs_owned) == nrow(df)
