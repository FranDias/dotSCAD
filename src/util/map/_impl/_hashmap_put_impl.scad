use <../../some.scad>;
use <../../find_index.scad>;

function _hashmap_put(buckets, b_numbers, key, value, eq, hash) =
    let(
	    b_idx = hash(key) % b_numbers,
		bucket = buckets[b_idx],
		k_idx = find_index(bucket, function(kv) eq(kv[0], key))
	)
	k_idx != -1 ? _replace(buckets, b_numbers, bucket, key, value, b_idx, k_idx) : 
	              _put(buckets, b_numbers, bucket, key, value, b_idx);

function _replace(buckets, b_numbers, bucket, key, value, b_idx, k_idx) = 
    let(leng_bucket = len(bucket))
	[
		for(bi = 0; bi < b_numbers; bi = bi + 1) 
		if(bi == b_idx) 
		    [for(ki = 0; ki < leng_bucket; ki = ki + 1) ki == k_idx ? [key, value] : bucket[ki]] 
		else 
		    buckets[bi]
	];

function _put(buckets, b_numbers, bucket, key, value, b_idx) = 
    [for(i = 0; i < b_numbers; i = i + 1) i == b_idx ? [each bucket, [key, value]] : buckets[i]];