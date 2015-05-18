#define F_DAMAGE_CACHE_TICKER 10
#define F_DAMAGE_CACHE_HIT(ENTRY) ENTRY.count = F_DAMAGE_CACHE_TICKER; result = ENTRY.value
#define F_DAMAGE_CACHE_MISS(ENTRY) ENTRY.count--; if (ENTRY.count == 0) del(ENTRY)

__f_damage_CacheEntry
	var
		key
		value
		count

	New(var/key, var/value, var/count)
		src.key		= key
		src.value 	= value
		src.count 	= count

__f_damage_Cache
	var
		list/entries = new()

	proc
		get(var/key)
			var/result = null
			for (var/__f_damage_CacheEntry/E in src.entries)
				if (E.key == key)
					F_DAMAGE_CACHE_HIT(E)
				else
					F_DAMAGE_CACHE_MISS(E)
			return result

		put(var/key, var/value)
			var/__f_damage_CacheEntry/E = new(key, value, F_DAMAGE_CACHE_TICKER)
			entries.Add(E)


#undef F_DAMAGE_CACHE_TICKER
#undef F_DAMAGE_CACHE_HIT
#undef F_DAMAGE_CACHE_MISS