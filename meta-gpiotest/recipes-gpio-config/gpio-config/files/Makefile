CROSS_COMPILE=

ifeq ($(CC),)
	CC=$(CROSS_COMPILE)gcc
endif

ifeq ($(CFLAGS),)
	CFLAGS= -g -Wall -Werror
endif

ifeq ($(LDFLAGS),)
	LDFLAGS= -lgpiod
endif

all: gpioreadtest gpiowritetest
default: gpioreadtest gpiowritetest

gpioreadtest : gpio_read.o
	$(CROSS_COMPILE)$(CC) $(CFLAGS) -o gpioreadtest gpio_read.o $(LDFLAGS)

gpiowritetest : gpio_write.o
	$(CROSS_COMPILE)$(CC) $(CFLAGS) -o gpiowritetest gpio_write.o $(LDFLAGS)

gpio_read.o : gpio_read.c
	$(CROSS_COMPILE)$(CC) $(CFLAGS) -c gpio_read.c $(LDFLAGS)

gpio_write.o : gpio_write.c
	$(CROSS_COMPILE)$(CC) $(CFLAGS) -c gpio_write.c $(LDFLAGS)

clean :
	rm -f gpioreadtest gpiowritetest *.o
