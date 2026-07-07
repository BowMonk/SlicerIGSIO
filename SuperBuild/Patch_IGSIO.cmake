# Patch_IGSIO.cmake — newer VTK stopped propagating these headers transitively,
# so link the providing modules explicitly. Run from External_IGSIO.cmake PATCH_COMMAND:
#   cmake -DSRC=<IGSIO source dir> -P Patch_IGSIO.cmake
if(NOT SRC)
  message(FATAL_ERROR "Patch_IGSIO: SRC not set")
endif()

# SequenceIO headers include <vtk_zlib.h>  (provided by VTK::zlib)
set(_f "${SRC}/SequenceIO/CMakeLists.txt")
file(READ "${_f}" _c)
if(NOT _c MATCHES "VTK::zlib")
  file(APPEND "${_f}" "\n# --- patched: provide vtk_zlib.h ---\ntarget_link_libraries(vtkSequenceIO PUBLIC VTK::zlib)\n")
  message(STATUS "Patch_IGSIO: vtkSequenceIO -> VTK::zlib")
endif()

# vtkIGSIOVolumeReconstructor.cxx includes <vtkDataSetWriter.h>  (provided by VTK::IOLegacy)
set(_f "${SRC}/VolumeReconstruction/CMakeLists.txt")
file(READ "${_f}" _c)
if(NOT _c MATCHES "VTK::IOLegacy")
  file(APPEND "${_f}" "\n# --- patched: provide vtkDataSetWriter.h ---\ntarget_link_libraries(vtkVolumeReconstruction PRIVATE VTK::IOLegacy)\n")
  message(STATUS "Patch_IGSIO: vtkVolumeReconstruction -> VTK::IOLegacy")
endif()
