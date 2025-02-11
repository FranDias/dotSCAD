use <_vt_default_comparator.scad>;

function _vt_sort(lt) = 
    let(leng = len(lt))
    leng <= 1 ? lt : 
        let(
            pivot = lt[0],
            before = [for(j = 1; j < leng; j = j + 1) if(lessThan(lt[j], pivot)) lt[j]],
            after =  [for(j = 1; j < leng; j = j + 1) if(greaterThan(lt[j], pivot) || lt[j] == pivot) lt[j]]
        )
        [each _vt_sort(before), pivot, each _vt_sort(after)];

function _sort_by_idx(lt, i) = 
    let(leng = len(lt))
    leng <= 1 ? lt : 
        let(
            pivot = lt[0],
            before = [for(j = 1; j < leng; j = j + 1) if(lt[j][i] < pivot[i]) lt[j]],
            after =  [for(j = 1; j < leng; j = j + 1) if(lt[j][i] >= pivot[i]) lt[j]]
        )
        [each _sort_by_idx(before, i), pivot, each _sort_by_idx(after, i)];

function _sort_by(lt, by, idx) =
    let(
        dict = [["x", 0], ["y", 1], ["z", 2], ["i", idx]],
        i = dict[search(by == "idx" ? "i" : by, dict)[0]][1]
    )
    _sort_by_idx(lt, i);

function _sort_by_cmp(lt, cmp) = 
    let(leng = len(lt))
    leng <= 1 ? lt : 
        let(
            pivot = lt[0],
            before = [for(j = 1; j < leng; j = j + 1) if(cmp(lt[j], pivot) < 0) lt[j]],
            after =  [for(j = 1; j < leng; j = j + 1) if(cmp(lt[j], pivot) >= 0) lt[j]]
        )
        [each _sort_by_cmp(before, cmp), pivot, each _sort_by_cmp(after, cmp)];
