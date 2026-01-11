

#include <mega328p.h>
#include "hardware.h"

#define TRACK_POWER_PORT PORTC
#define TRACK_POWER_DDR  DDRC
#define TRACK_POWER_PIN  5   // PC5 (example)

void track_power_on(void)
{
    TRACK_POWER_DDR |= (1 << TRACK_POWER_PIN);   // ensure output
    TRACK_POWER_PORT |= (1 << TRACK_POWER_PIN);  // relay ON
}

void track_power_off(void)
{
    TRACK_POWER_DDR |= (1 << TRACK_POWER_PIN);
    TRACK_POWER_PORT &= ~(1 << TRACK_POWER_PIN); // relay OFF
}
