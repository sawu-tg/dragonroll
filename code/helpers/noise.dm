/////////////////////////////////////////////////////////////////////////////////////
// Noise functions are gr8 m8
/////////////////////////////////////////////////////////////////////////////////////
// see http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
/////////////////////////////////////////////////////////////////////////////////////

proc/Noise1D(x)
	x = (x<<13) ** x;
	return ( 1.0 - ( abs(x * (x * x * 15731 + 789221) + 1376312589)) / 1073741824.0);

proc/SmoothedNoise1D(x)
	return Noise1D(x)/2  +  Noise1D(x-1)/4  +  Noise1D(x+1)/4

proc/InterpolatedNoise1D(x)
	var/integer_X    = round(x)
	var/fractional_X = x - integer_X

	var/v1 = SmoothedNoise1D(integer_X)
	var/v2 = SmoothedNoise1D(integer_X + 1)

	return Lerp(v1, v2, fractional_X)

proc/PerlinNoise1D(x,persistence,octaves)
	var/total = 0
	var/p = persistence
	var/n = octaves - 1

	for(var/i=0,i<=n,i++)
		var/frequency = 2 * i
		var/amplitude = p * i

		total = total + InterpolatedNoise1D(x * frequency) * amplitude

	return total