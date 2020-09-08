include_directories(.)

set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")

set(SRCS
    classifier/naive_bayes.cpp
    util/array.h)

add_library(fishlearning SHARED ${SRCS})

add_executable(hue demo/hue.cpp)
target_link_libraries(hue fishlearning)
