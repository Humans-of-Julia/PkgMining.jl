using PkgMining
using DataFrames
using Test

@testset "basic" begin
    let df = pkg_mining(), df_owners = combine(groupby(df, :owner), nrow => :pkgs_owned)
        @test nrow(df) > 1
        @test nrow(df_owners) > 1
        @test sum(df_owners.pkgs_owned) == nrow(df)
    end
end