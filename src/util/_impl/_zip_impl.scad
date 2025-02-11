_identity = function(elems) elems;

function _zipAll_sub(lts, list_to, elem_to, combine, i = 0) = 
    i > elem_to ? [] :
    concat(
        [combine([for(j = [0:list_to]) lts[j][i]])], 
        _zipAll_sub(lts, list_to, elem_to, combine, i + 1)
    );

function _zipAll(lts, combine = _identity) = _zipAll_sub(lts, len(lts) - 1, len(lts[0]) - 1, combine);