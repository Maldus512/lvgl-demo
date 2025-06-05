#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include "lvgl.h"


int main(void) {
    lv_init();

    lv_sdl_window_create(320, 320); // Create an SDL window
    lv_sdl_mouse_create();          // Connect an input device (the mouse)

    // Create a button
    lv_obj_t *button = lv_button_create(lv_screen_active());
    lv_obj_center(button);
    // A label inside it
    lv_obj_t *label = lv_label_create(button);
    lv_label_set_text(label, "Click me!"); // Initial text
    lv_obj_center(label);

    for (;;) {
        lv_timer_handler();
        usleep(5 * 1000);
    }
}
