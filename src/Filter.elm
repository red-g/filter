module Filter exposing (Filter, all, and, any, by, custom, eq, fail, gt, list, lt, not, or, pass, test)


type Filter a
    = Filter (a -> Bool)


lt : Int -> Filter Int
lt left =
    custom <| (<) left


gt : Int -> Filter Int
gt left =
    custom <| (>) left


eq : a -> Filter a
eq item =
    Filter <| eq_ item


eq_ : a -> a -> Bool
eq_ ref item =
    ref == item


and : Filter a -> Filter a -> Filter a
and (Filter left) (Filter right) =
    Filter <| and_ left right


and_ : (a -> Bool) -> (a -> Bool) -> a -> Bool
and_ left right item =
    left item && right item


or : Filter a -> Filter a -> Filter a
or (Filter left) (Filter right) =
    Filter <| or_ left right


or_ : (a -> Bool) -> (a -> Bool) -> a -> Bool
or_ left right item =
    left item || right item


not : Filter a -> Filter a
not (Filter filter) =
    Filter <| not_ filter


not_ : (a -> Bool) -> a -> Bool
not_ filter item =
    Basics.not <| filter item


custom : (a -> Bool) -> Filter a
custom =
    Filter


by : (a -> b) -> Filter b -> Filter a
by derived (Filter filter) =
    Filter <| by_ derived filter


by_ : (a -> b) -> (b -> Bool) -> a -> Bool
by_ derived filter item =
    filter <| derived item


list : Filter a -> List a -> List a
list filter =
    List.filter (test filter)


test : Filter a -> a -> Bool
test (Filter filter) item =
    filter item


pass : Filter a
pass =
    Filter pass_


pass_ : a -> Bool
pass_ _ =
    True


fail : Filter a
fail =
    Filter fail_


fail_ : a -> Bool
fail_ _ =
    False


all : List (Filter a) -> Filter a
all filters =
    List.foldl and pass filters


any : List (Filter a) -> Filter a
any filters =
    List.foldl or fail filters
