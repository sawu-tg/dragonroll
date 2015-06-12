/////////////////////////////////////////////////////////////////////////////////////
// Noise functions are gr8 m8
/////////////////////////////////////////////////////////////////////////////////////
// see http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
/////////////////////////////////////////////////////////////////////////////////////

/datum/noise
	var/prime_a
	var/prime_b
	var/prime_c
	var/prime_d

	var/prime_coord

/datum/noise/New()
	prime_a = GetNextPrime(rand(100,1000))
	prime_b = GetNextPrime(rand(1000,9999))
	prime_c = GetNextPrime(rand(1000,9999))
	prime_d = GetNextPrime(rand(1000,9999))
	prime_coord = GetNextPrime(rand(10,100))

//Basicly this doesn't work.
/*/datum/noise/proc/Noise1D(x)
	x = (x / (2 ** 13)) * x;

	return ( 1.0 - ( abs(x * (x * x * prime_a + prime_b) + prime_c)) / prime_d);*/

/datum/noise/proc/Noise1D(x)
	x = 1.0 * x * (x * prime_a + prime_b) + prime_c
	x = Wrap(x, 0, prime_d) / prime_d

	return x
	//return ( 1.0 - ( abs(x * (x * x * prime_a + prime_b) + prime_c)) / prime_d);

/datum/noise/proc/Noise2D(x,y)
	return Noise1D(x + y * prime_coord)

/datum/noise/proc/SmoothedNoise1D(x)
	return Noise1D(x)/2.0  +  Noise1D(x-1)/4.0  +  Noise1D(x+1)/4.0

/datum/noise/proc/SmoothedNoise2D(x,y)
	var/corners = ( Noise2D(x-1, y-1)+Noise2D(x+1, y-1)+Noise2D(x-1, y+1)+Noise2D(x+1, y+1) ) / 16.0
	var/sides   = ( Noise2D(x-1, y)  +Noise2D(x+1, y)  +Noise2D(x, y-1)  +Noise2D(x, y+1) ) /  8.0
	var/center  = Noise2D(x, y) / 4.0

	//world << "Smooth [corners] + [sides] + [center] = [corners + sides + center]"

	return corners + sides + center

/datum/noise/proc/InterpolatedNoise1D(x)
	var/integer_X    = round(x)
	var/fractional_X = x - integer_X

	var/v1 = SmoothedNoise1D(integer_X)
	var/v2 = SmoothedNoise1D(integer_X + 1)

	return Lerp(v1, v2, fractional_X)

/datum/noise/proc/InterpolatedNoise2D(x,y)
	var/integer_X    = round(x)
	var/fractional_X = x - integer_X

	var/integer_Y    = round(y)
	var/fractional_Y = y - integer_Y

	var/v1 = SmoothedNoise2D(integer_X    ,integer_Y    )
	var/v2 = SmoothedNoise2D(integer_X + 1,integer_Y    )
	var/v3 = SmoothedNoise2D(integer_X    ,integer_Y + 1)
	var/v4 = SmoothedNoise2D(integer_X + 1,integer_Y + 1)

	var/i1 = Lerp(v1, v2, fractional_X)
	var/i2 = Lerp(v3, v4, fractional_X)

	return Lerp(i1, i2, fractional_Y)

/datum/noise/proc/PerlinNoise1D(x,persistence,octaves)
	var/total = 0
	var/p = persistence
	var/n = octaves - 1

	for(var/i=0,i<=n,i++)
		var/frequency = 2 * i
		var/amplitude = p * i

		total = total + InterpolatedNoise1D(x * frequency) * amplitude

	return total

/datum/noise/proc/PerlinNoise2D(x,y,persistence,octaves)
	var/total = 0
	var/p = persistence
	var/n = octaves - 1

	for(var/i=0,i<=n,i++)
		var/frequency = 2 ** i
		var/amplitude = p ** i

		total = total + InterpolatedNoise2D(x * frequency,y * frequency) * amplitude

	return total