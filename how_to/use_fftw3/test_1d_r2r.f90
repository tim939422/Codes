program test_1d_r2r
    use, intrinsic :: iso_c_binding
    use m_fftw3
    implicit none

    integer, parameter :: N = 8
    type(c_ptr)    :: plan
    real(c_double), dimension(N) :: in
    real(c_double), dimension(N) :: out
    integer :: i, iunit

    plan = fftw_plan_r2r_1d(N, in, out, FFTW_R2HC, FFTW_ESTIMATE)

    in = [1.0_c_double,  &
          2.3_c_double,  &
          1.4_c_double,  &
          4.0_c_double,  &
          1.32_c_double, &
          3.0_c_double,  &
          1.0_c_double,  &
          4.2_c_double]
    call fftw_execute_r2r(plan, in, out)


    ! Print the output

    open(newunit=iunit, file="test_1d_r2r.txt")
    write(iunit, '(A)')  "# Output of FFT:"
    write(iunit, '(A)')  "#   i         out(i)"
    do i = 1, N
        write(iunit, '(i5, es23.15)') i - 1, out(i)
    end do
    close(iunit)

    call fftw_destroy_plan(plan)
end program test_1d_r2r