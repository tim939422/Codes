cmake_minimum_required(VERSION 3.21)                        
cmake_policy(SET CMP0074 NEW)
project(FortranFFTW LANGUAGES Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/.modules)
include(cmake/fft.cmake)


set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})

# Initialize a list for all executables
set(EXECUTABLES dummy.exe)

add_executable(dummy.exe
    dummy.f90
    m_fftw3.f90
)
target_include_directories(dummy.exe PRIVATE ${FFTW_INCLUDE_DIRS})
target_link_libraries(dummy.exe PRIVATE ${FFTW_DOUBLE_LIB})

# Build all FFTW 3 test files
file(GLOB ALL_TEST_FILES *.f90)
list(REMOVE_ITEM ALL_TEST_FILES ${CMAKE_SOURCE_DIR}/m_fftw3.f90 ${CMAKE_SOURCE_DIR}/dummy.f90)
foreach(SRC_FILE ${ALL_TEST_FILES})
    # set executable names
    get_filename_component(EXEC_NAME ${SRC_FILE} NAME_WE)
    set(EXEC_NAME_WITH_SUFFIX "${EXEC_NAME}.exe")
    message(STATUS "Configuring: ${EXEC_NAME_WITH_SUFFIX}")

    add_executable(${EXEC_NAME_WITH_SUFFIX} ${SRC_FILE} m_fftw3.f90)
    target_include_directories(${EXEC_NAME_WITH_SUFFIX} PRIVATE ${FFTW_INCLUDE_DIRS})
    target_link_libraries(${EXEC_NAME_WITH_SUFFIX} PRIVATE ${FFTW_DOUBLE_LIB})

    # Append the executable to the list
    list(APPEND EXECUTABLES ${EXEC_NAME_WITH_SUFFIX})
endforeach(SRC_FILE ${ALL_TEST_FILES})

# Install all executables
install(TARGETS ${EXECUTABLES}
    RUNTIME DESTINATION run
)
