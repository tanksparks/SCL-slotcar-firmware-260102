

#include <mega328p.h>
#include "hardware.h"

#define TRACK_POWER_PORT PORTB
#define TRACK_POWER_DDR  DDRB
#define TRACK_POWER_PIN  2   // PB2 (example)

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
