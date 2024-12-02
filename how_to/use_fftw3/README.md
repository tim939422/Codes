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
## Lessons
### in-place plan
While I wrote the FFT accelerated Poisson solver, I plan the in-place real to
real FFT as this
```fortran
    ...
    real(rp) :: in(nx, ny), out(nx, ny)
    ...
    plan = fftw_plan_guru_r2r(rank, dims, howmany_rank, howmany_dims, in, out, [itype], FFTW_ESTIMATE)
```
This works fine up to a $128^2$ array. However, my Poisson solver fails at $256^2$.
After intensive debug, I find the problem is in the FFT since the backward transform
cannot recover the original data after scaling. Therefore, now, I plan as
```fortran
    ...
    real(rp) :: in(nx, ny)
    ...
    plan = fftw_plan_guru_r2r(rank, dims, howmany_rank, howmany_dims, in, in, [itype], FFTW_ESTIMATE)
```
It works until $8192^2$. I don't know the reason. However, I learn a lesson as
**Plan in-place transform with same array**.