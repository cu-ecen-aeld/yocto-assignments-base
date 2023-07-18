/*********************************************************
 *
 *  Gpio_read.c - Test file to check working of lgpiod lib
 *  
 *  Reference - https://ostconf.com/system/attachments/
 *  files/000/001/532/original/
 *  Linux_Piter_2018_-_New_GPIO_interface_for_linux_userspace.pdf?1541021776
 *
 ********************************************************/

#include <stdio.h>
#include <gpiod.h>

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

    rv = gpiod_line_request_input(line, "foobar");

    if (rv) 
    {
     gpiod_chip_close(chip);
     return -1;
    }

    value = gpiod_line_get_value(line);
    printf("GPIO%d value is %d\n", GPIO_PIN, value);
    gpiod_chip_close(chip);

    return 0;
}
