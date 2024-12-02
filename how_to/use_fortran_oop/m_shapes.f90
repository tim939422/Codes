module m_shapes
    implicit none
    private
  
    type, public :: t_square
        private
        real :: side
    contains
        private
        procedure, public :: area  ! procedure declaration
        final :: cleanup
    end type
    
    interface t_square
        module procedure init
    end interface t_square
contains
    ! constructor
    function init(side) result(square)
        type(t_square) :: square

        real :: side
        square%side = side
    end function init

    ! destructor
    subroutine cleanup(this)
        type(t_square) :: this
        print *, "clean up"
    end subroutine cleanup

  
    ! Procedure definition
    real function area(self) result(res)
      class(t_square), intent(in) :: self
      res = self%side**2
    end function

    !
  
  end module m_shapes
  
  program main
    use m_shapes
    implicit none
  
    ! Variables' declaration
    type(t_square) :: sq
    real :: x, side
  
    ! Variables' initialization
    side = 0.5
    sq = t_square(side)
  
    x = sq%area()
    print *, x
  
  end program main