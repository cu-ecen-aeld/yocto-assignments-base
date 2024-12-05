/*********************************************************
 *
 *  Gpio_write.c - Test file to check working of lgpiod lib
 *  
 ********************************************************/

#include <stdio.h>
#include <gpiod.h>
#include <unistd.h>

#define GPIO_PIN    4

struct gpiod_chip *chip;
struct gpiod_line *line;
int rv, value;

int main()
{
    chip= gpiod_chip_open("/dev/gpiochip0");

    if (!chip)
     return -1;

    line = gpiod_chip_get_line(chip, GPIO_PIN);

    if (!line) 
    {
     gpiod_chip_close(chip);
     return -1; 
    }

    rv = gpiod_line_request_output(line, "foobar", 1);

    if (rv) 
    {
     gpiod_chip_close(chip);
     return -1;
    }

    value = gpiod_line_set_value(line, 0);
    printf("GPIO%d value is cleared to 0\n", GPIO_PIN);
    sleep(1);
    gpiod_chip_close(chip);

    return 0;
}
