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
        firstversion = String[],
        lastversion = String[],
        repo = String[],
        sha1 = String[]
    )

    @showprogress "Mining $(length(registry["packages"])) packages: " for (uuid, info) in
                                                                        registry["packages"]
        pkg = TOML.parsefile(joinpath(general, info["path"], "Package.toml"))
        versions = TOML.parsefile(joinpath(general, info["path"], "Versions.toml"))
        firstversion, lastversion = string.(extrema(VersionNumber.(keys(versions))))
        sha1 = versions[lastversion]["git-tree-sha1"]
        owner = split(pkg["repo"], '/')[end-1]
        push!(
            df,
            (
                info["name"],
                uuid,
                owner,
                0,
                firstversion,
                lastversion,
                pkg["repo"],
                sha1
            )
        )

    end
    
    return df
end

end
