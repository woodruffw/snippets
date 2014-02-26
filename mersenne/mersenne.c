/*	mersenne.c
	Author: William Woodruff
	------------------------
	A C99 implementation of the "Mersenne Twister" pseudorandom number generator (PRNG).
	Specifically, this is an implementation of MT19937 (32-bit seed, 32-bit results).
	------------------------
	Background:
	The Mersenne Twister was developed in 1997 by Makoto Matsumoto and Takuji Nishimura.
	It is significantly more "random" than linear congruential generators, possessing a period of 
	(2**19937)-1 and passing the Diehard tests.
	As a result, it's become the standard PRNG in many languages.
	It is NOT cryptographically secure, as its future iterations can be predicted after 624 previous.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static uint32_t twister[624];
static uint32_t index = 0;

/*	init
	initializes the PRNG, setting the first element to the seed
*/
void init(uint32_t seed)
{
	index = 0;
	twister[0] = seed;

	for (int i = 1; i < 624; i++)
	{
		twister[i] = (0x6c078965 * (twister[i - 1] ^ (twister[i - 1] >> 30)) + i);
		twister[i] &= 0xFFFFFFFF;
	}
}

/*	generate
	generates (fills) the array of 624 uints with untempered values
*/
void generate(void)
{
	for (int i = 0; i < 624; i++)
	{
		uint32_t v = (twister[i] & 0x80000000) + (twister[(i + 1) % 624] & 0x7fffffff);
		twister[i] = twister[(i + 397) % 624] ^ (v >> 1);

		if (v % 2)
		{
			twister[i] ^= 0x9908b0df;
		}
	}
}

/*	get
	returns a single number from the array based upon the current index, tempering it in the process
*/
uint32_t get(void)
{
	if (index == 0)
	{
		generate();
	}

	uint32_t v = twister[index];
	v ^= (v >> 11);
	v ^= ((v << 7) & 0x9D2C5680);
	v ^= ((v << 15) & 0xEFC60000);
	v ^= (v >> 18);

	index = (index + 1) % 624;

	return v;
}

int main(void)
{
	/* howto: provide init() with your seed, then call get() as required. */
	/*
	init(238);
	printf("%lu\n", (unsigned long) get());
	*/

	return EXIT_SUCCESS;
}