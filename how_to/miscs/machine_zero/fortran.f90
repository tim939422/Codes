program main
    implicit none
    
    integer, parameter :: sp = kind(1.0)
    integer, parameter :: dp = selected_real_kind(2*precision(1.0_sp))
    real(dp) :: machine_zero

    machine_zero = epsilon(1.0_dp)
    print '("machine zero (double) in Fortran", es23.15)', machine_zero

    block
        integer :: k
        real(dp) :: result
        k = 4
        result = 1.0_dp - tanh(1.2_dp*(1.0_dp - 2.0_dp*real(k, dp)/real(16, dp)))/tanh(1.2_dp)
        print *, result
    end block

    print *, precision(1.0_sp)
    print *, precision(1.0_dp)
    
end program main