    !	Copyright 2011 Johns Hopkins University
    !
    !  Licensed under the Apache License, Version 2.0 (the "License");
    !  you may not use this file except in compliance with the License.
    !  You may obtain a copy of the License at
    !
    !      http://www.apache.org/licenses/LICENSE-2.0
    !
    !  Unless required by applicable law or agreed to in writing, software
    !  distributed under the License is distributed on an "AS IS" BASIS,
    !  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    !  See the License for the specific language governing permissions and
    !  limitations under the License.


    program TurbTest

    use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_float, c_f_pointer
    implicit none

    integer, parameter :: RP=4
    character(*), parameter :: authtoken = 'edu.jhu.pha.turbulence.testing-201406' // CHAR(0)
    character(1) :: field

    integer, parameter :: t0=0, x0=0, y0=x0, z0=x0, nx=2, ny=nx, nz=nx
    integer, parameter :: x_step=1, y_step=1, z_step=1, filter_width=1
    integer :: size, i
    real(RP), allocatable :: result(:)

    ! Declare the return type of the turblib functions as integer.
    ! This is required for custom error handling (see the README).
    integer :: getanycutoutweb

    ! return code
    integer :: rc

    ! Formatting rules
    character(*), parameter :: rawformat1='(i4,1(a,f10.6))'

    !
    ! Intialize the gSOAP runtime.
    ! This is required before any WebService routines are called.
    !
    CALL soapinit()

    ! Enable exit on error.  See README for details.
    CALL turblibSetExitOnError(1)


    print *, ".........getAnyCutoutWeb........."

    print *, "......isotropic1024coarse u......";
    field='u'
    if (field=='u') then
        size = nx*ny*nz*3;
    else if (field=='p') then
        size = nx*ny*nz;
    end if
    allocate(result(size))
    print *, field=='u', size

    rc = getanycutoutweb (authtoken, "isotropic1024coarse", field, t0, x0, y0, z0, &
        nx, ny, nz, x_step, y_step, z_step, filter_width, result)
    do i = 1, size
        write(*,rawformat1) i, ': ', result(i)
    end do
    deallocate(result)

    print *, ".........transition_bl p.........";
    field='p'
    if (field=='u') then
        size = nx*ny*nz*3;
    else if (field=='p') then
        size = nx*ny*nz;
    end if
    allocate(result(size))
    print *, field=='p', size

    rc = getanycutoutweb (authtoken, "transition_bl", field, t0, x0, y0, z0, &
        nx, ny, nz, x_step, y_step, z_step, filter_width, result)
    do i = 1, size
        write(*,rawformat1) i, ': ', result(i)
    end do
    deallocate(result)
    !
    ! Destroy the gSOAP runtime.
    ! No more WebService routines may be called.
    !
    CALL soapdestroy()

    end program TurbTest
