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


program GetTBL

  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_float, c_f_pointer
  implicit none

  integer, parameter :: RP=4
  character(*), parameter :: authtoken = 'cn.edu.ustc.mail.boliu128-285c1f8f' // CHAR(0)
  character(1) :: field

  integer :: time_step
  integer, parameter :: x_start=676, y_start=1, z_start=801, x_end=775, y_end=80, z_end=870
  integer, parameter :: x_step=1, y_step=1, z_step=1, filter_width=1
  integer :: size, i
  real(RP), allocatable :: result(:)

  ! Declare the return type of the turblib functions as integer.
  ! This is required for custom error handling (see the README).
  integer :: getcutout

  ! return code
  integer :: rc

  ! Formatting rules
  character(*), parameter :: rawformat1='(i6,1(a,f10.6))'
  character(4) :: ch_step

  !
  ! Intialize the gSOAP runtime.
  ! This is required before any WebService routines are called.
  !
  CALL soapinit()

  ! Enable exit on error.  See README for details.
  CALL turblibSetExitOnError(1)

  print *, ".........transition_bl u.........";
  field='u'
  if (field=='u') then
    size = (x_end-x_start+1)/x_step * (y_end-y_start+1)/y_step * (z_end-z_start+1)/z_step*3;
  else if (field=='p') then
    size = (x_end-x_start+1)/x_step * (y_end-y_start+1)/y_step * (z_end-z_start+1)/z_step;
  end if
  allocate(result(size))
  print *, field=='u', size

  do time_step = 1,50,1
    write (ch_step, '(I4.4)') time_step
    ! Load data
    write(*,*) '  load '//ch_step
    rc = getcutout (authtoken, "transition_bl", field, time_step, x_start, y_start, z_start, &
      x_end, y_end, z_end, x_step, y_step, z_step, filter_width, result)

    ! Write data
    write(*,*) '  write '//ch_step
    open(13,file='tbl_local.'//ch_step,form='unformatted')
    write(13) result
    close(13)
  end do

  deallocate(result)
  !
  ! Destroy the gSOAP runtime.
  ! No more WebService routines may be called.
  !
  CALL soapdestroy()

end program GetTBL

