# Use FFTW in a Fortran Project

## Create module `m_fftw3`
Just create a file `m_fftw3.f90`, and the contents are
```fortran
module m_fftw3
    use, intrinsic :: iso_c_binding
    implicit none
    include 'fftw3.f03'
end module m_fftw3
```
For linting purpose, I copy all contents of `fftw3.f03` to `m_fftw3.f90`.

## Use CMake to build a project with FFTW3
1. In a new project, create a `cmake` folder which consists of
    ```bash
    cmake
    ├── downloadFindFFTW.cmake.in
    └── fft.cmake
    ```
    For the purpose of these files, see the corresponding header information.
2. In the main `CMakeLists.txt` (located at `CMAKE_SOURCE_DIR`), you should add
    ```cmake
    include(cmake/fft.cmake)
    ```
To make the process work, we should either configure like
```bash
cmake -S . -B build -DFFTW_ROOT=/path/to/fftw3/install
```
or configure an environment variable
```bash
export FFTW_ROOT=/path/to/fftw3/install
```
On my MacBook, the correct path is `/Users/duosifan/Codes/fftw/3.3.10`.

## Linter settings in VSCode
1. modify the main `CMakeLists.txt` with
    ```cmake
    set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/.modules)
    ```
    and we always folder `build` for `PROJECT_BINARY_DIR`.
2. Create the `settings.json` inside `.vscode` folder as
   ```json
    {
    "fortran.linter.includePaths": [
        "${workspaceFolder}/build/.modules/**"
    ],
    "fortran.linter.extraArgs": [
        "-J${workspaceFolder}/build/.modules"
    ]
    }
   ```
    which is portable enough for most projects.