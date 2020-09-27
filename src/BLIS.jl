module BLIS

using Libdl
using blis_jll: blis

using LinearAlgebra
import LinearAlgebra.BLAS: gemm!, gemm
import LinearAlgebra.BLAS: hemm!, hemm
import LinearAlgebra.BLAS: symm!, symm
import LinearAlgebra.BLAS: gemv!, gemv

global libblis = C_NULL

__init__() = begin
    if length(get(ENV, "BLISDIR", "")) > 0
        # BLIS installation overriden by environmental variables.
        @info "Using custom defined BLIS installation instead of blis_jll."
        global libblis = dlopen(string(get(ENV, "BLISDIR", ""), "/lib/libblis"))
    else
        # Use BinaryBuilder provided BLIS library.
        global libblis = dlopen(blis)
    end
end

# Data types.
include("types.jl")

# Backend macros.
include("backend_typed/common.jl")
include("backend_typed/level1v.jl")
include("backend_typed/level1d.jl")
include("backend_typed/level1m.jl")
include("backend_typed/level1f.jl")
include("backend_typed/level2.jl")
include("backend_typed/level3.jl")
include("backend_typed/utility.jl")

# LinearAlgebra BLAS interface.
include("interface_linalg/gemm.jl")
include("interface_linalg/hemm.jl")
include("interface_linalg/trmm.jl")
include("interface_linalg/her2k.jl")

end

