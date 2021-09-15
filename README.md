# PkgMining

Mining Julia General Registry for Package info.

This package is still in an embrionary stage and is not registered.

## Functionality

This package exports a single function called `pkg_mining()`, which returns a `DataFrame` with all the currently registered packages and some info about them.

The current columns in the `DataFrame` are the following

* `name::String`: name of the package
* `uuid::String[]` - UUID of the package
* `owner::String[]` - owner (user or organization) of the package at github or gitlab
* `pkgs_owned::Int[]` - number of packages owned by the same owner
* `firstversion::String[]` - first registered version of the package
* `lastversion::String[]` - latest registered version of the package (according to the Registry queried, which may ot be updated)
* `repo::String[]` - url of the github or gitlab repository
* `sha1::String[]` - git-tree-sha1 of the latest registered version of the package (see `lastversion`)

## Basic usage

One starts by populating a DataFrame with the package info. You may want to first update the environment with `]up` (or similar) to get the current General Registry info.

```julia
julia> using DataFrames

julia> using PkgMining

julia> df = pkg_mining()
Mining 6371 packages: 100%|█████████████████████████████████████████████| Time: 0:00:04
6371×8 DataFrame
  Row │ name                           uuid                               owner                ⋯
      │ String                         String                             String               ⋯
──────┼─────────────────────────────────────────────────────────────────────────────────────────
    1 │ COSMA_jll                      0efae8bf-39e6-5d65-b05d-c8947f4c…  JuliaBinaryWrappers  ⋯
  ⋮   │               ⋮                                ⋮                           ⋮           ⋱
 6371 │ TopicModelsVB                  dad468f8-6d63-5d40-b2c4-48631a3e…  ericproffitt
                                                                 5 columns and 6369 rows omitted
```

Then, we can query the DataFrame as we wish.

```julia
julia> df[df.owner .== "JuliaImages", :name] # list of packages owned by `JuliaImages`
26-element Vector{String}:
 "ImageMetadata"
 "HistogramThresholding"
 "ImageDistances"
 "TestImages"
 "ImageInpainting"
 "Images"
 "ImageMorphology"
 "ImageSmooth"
 "ImageBase"
 "ImageView"
 "ImageInTerminal"
 "ImageContrastAdjustment"
 "ImageEdgeDetection"
 "ImageFeatures"
 "ImageShow"
 "ImageQualityIndexes"
 "ImageCore"
 "ImageDraw"
 "ImageFiltering"
 "ImageTransformations"
 "ImageAxes"
 "ImageNoise"
 "DitherPunk"
 "ImageTracking"
 "IntegralArrays"
 "ImageSegmentation"

julia> df[df.name .== "BenchmarkTools", :owner] # owner of package `BenchmarkTools`
1-element Vector{String}:
 "JuliaCI"

julia> nrow(df[df.owner .== "JuliaAudio", :]) # number of packages owned by JuliaAudio
4
```

We can also build another DataFrame with the owners and the number of packages they own (Thanks to ).

```julia
julia> df_owners = combine(groupby(df, :owner), nrow => :pkgs_owned)
1772×2 DataFrame
  Row │ owner                pkgs_owned 
      │ String               Int64      
──────┼─────────────────────────────────
    1 │ JuliaBinaryWrappers         822
    2 │ cite-architecture             7
    3 │ trixi-framework               6
    4 │ wsphillips                    3
  ⋮   │          ⋮               ⋮
 1769 │ focusenergy                   1
 1770 │ chrisbrahms                   1
 1771 │ Datax-package                 1
 1772 │ ericproffitt                  1
                       1764 rows omitted

julia> sort(df_owners, :pkgs_owned, rev = true)[1:15, :]
15×2 DataFrame
 Row │ owner                  pkgs_owned 
     │ String                 Int64      
─────┼───────────────────────────────────
   1 │ JuliaBinaryWrappers           822
   2 │ SciML                          79
   3 │ JuliaIO                        43
   4 │ scheinerman                    42
   5 │ invenia                        41
   6 │ BioJulia                       41
   7 │ JuliaPOMDP                     40
   8 │ JuliaMath                      39
   9 │ JuliaSmoothOptimizers          37
  10 │ JuliaData                      31
  11 │ tpapp                          30
  12 │ queryverse                     29
  13 │ tkf                            29
  14 │ jump-dev                       29
  15 │ JuliaAI                        27

julia> nrow(df_owners[df_owners.pkgs_owned .≥ 10, :]) # number of owners of 10+ packages
110

julia> nrow(df_owners[df_owners.pkgs_owned .< 10, :]) # number of owners of less than 10 packages
1662

julia> sum(df_owners.pkgs_owned) # total number of packages from df_owners
6371

julia> sum(df_owners[df_owners.pkgs_owned .≥ 10, :pkgs_owned]) # number of packages in the first group
2843

julia> sum(df_owners[df_owners.pkgs_owned .< 10, :pkgs_owned]) # number of packages in the second group
3528
```

## To do (Contributions are welcome)

* One plan is to query the repository to extract data such as number of stargazers and watchers, number of forks, number of projects, homepage, and so on. This doesn't need to be included in the DataFrame. We should provide a function that takes the package name and returns the info. The info is contained in `https://api.github.com/repos/[owner]/[package_name_with_dot_jl_if_needed]`. For example, checkout out [SciML/DifferentialEquations github info](https://api.github.com/repos/SciML/DifferentialEquations.jl).

* Another idea is to read the General Registry directly from github, so it always picks up the latest version.
