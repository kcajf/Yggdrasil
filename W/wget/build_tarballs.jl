# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "wget"
version = v"1.20.3"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://ftp.gnu.org/gnu/wget/wget-1.20.3.tar.gz", "31cccfc6630528db1c8e3a06f6decf2a370060b982841cfab2b8677400a5092e")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/wget-1.20.3/
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make -j4
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64)
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("wget", :wget)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency(PackageSpec(name="GnuTLS_jll", uuid="0951126a-58fd-58f1-b5b3-b08c7c4a876d"))
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
