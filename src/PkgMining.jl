module PkgMining

using TOML
using ProgressMeter
using DataFrames

export pkg_mining

function pkg_mining()
    general = joinpath(homedir(), ".julia", "registries", "General")
    registry = TOML.parsefile(joinpath(general, "Registry.toml"))

    df = DataFrame(
        name = String[],
        uuid = String[],
        owner = String[],
        pkgs_owned = Int[],
        repo = String[]
    )

    @showprogress "Mining $(length(registry["packages"])) packages: " for (uuid, info) in
                                                                        registry["packages"]
        pkg = TOML.parsefile(joinpath(general, info["path"], "Package.toml"))
        owner = split(pkg["repo"], '/')[end-1]
        push!(df, (info["name"], uuid, owner, 0, pkg["repo"]))
    end

    df.pkgs_owned = [size(df[df.owner .== owner, :], 1) for owner in df.owner]
    return df
end

end
