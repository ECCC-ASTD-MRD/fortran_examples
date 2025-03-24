Test failed build with `ifx` with `intent(inout)`

The build fails with the Intel Fortran compiler 2025.0.4 (`ifx`) if
the `-warn all` option is pecified. That option is added if 
`WITH_WARNINGS` is enabled.

The build works with `ifx` if the `-warn all` option isn't present.

The build also works with `gfortran` 14.2 even if warnings are enabled.

## Compilation instructions
```
mkdir $build_dir_path
cd $build_dir_path
export FC=ifx
cmake -DWITH_WARNINGS=ON $src_dir_path
make
```

### Build config

Options to configure compilation must be added with the `-D` prefix when
calling the `cmake` command.

`WITH_WARNINGS`
: `(ON|OFF)` Compilation mode. Default: `OFF`
