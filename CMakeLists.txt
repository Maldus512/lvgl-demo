cmake_minimum_required(VERSION 3.10)

project(lvgl-demo)

file(GLOB_RECURSE SOURCES lib/lvgl/src/*.c)

add_executable(lvgl_demo src/main.c ${SOURCES})
target_include_directories(lvgl_demo PRIVATE lib/lvgl)
target_link_libraries(lvgl_demo -lSDL2)
