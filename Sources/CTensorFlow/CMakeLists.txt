add_library(CTensorFlow STATIC
  CTensorFlow.cc)
target_include_directories(CTensorFlow PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(CTensorFlow PUBLIC
  tensorflow)
