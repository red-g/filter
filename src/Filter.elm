module Filter exposing (Filter, all, and, any, array, by, custom, eq, fail, gt, list, lt, not, or, pass, test)

import Array exposing (Array)


{-| Useful ways to combine filters (also known as predicates)!
-}


{-| A `Filter` takes a value `a` and determines whether it should pass or fail.
-}
type Filter a
    = Filter (a -> Bool)


{-| Test whether a value is less than `num`.
-}
lt : Int -> Filter Int
lt num =
    custom <| (>) num


{-| Test whether a value is greater than `num`.
-}
gt : Int -> Filter Int
gt num =
    custom <| (<) num


{-| Test whether a value is equal to `item`.
-}
eq : a -> Filter a
eq item =
    Filter <| eq_ item


eq_ : a -> a -> Bool
eq_ ref item =
    ref == item


{-| Pass if both filters pass.
-}
and : Filter a -> Filter a -> Filter a
and (Filter left) (Filter right) =
    Filter <| and_ left right


and_ : (a -> Bool) -> (a -> Bool) -> a -> Bool
and_ left right item =
    left item && right item


{-| Pass if at least one filter passes.
-}
or : Filter a -> Filter a -> Filter a
or (Filter left) (Filter right) =
    Filter <| or_ left right


or_ : (a -> Bool) -> (a -> Bool) -> a -> Bool
or_ left right item =
    left item || right item


{-| Flip the outcome of a filter; if it fails it passes, and if it passes it fails.
-}
not : Filter a -> Filter a
not (Filter filter) =
    Filter <| not_ filter


not_ : (a -> Bool) -> a -> Bool
not_ filter item =
    Basics.not <| filter item


{-| Sometimes the building blocks in this library aren't enough!
-}
custom : (a -> Bool) -> Filter a
custom =
    Filter


{-| Filter a value by a derived property, like its height.

    bob =
        { height = 5 }

    isTall =
        by .height <| gt 6

    test isTall bob
    -- False

-}
by : (a -> b) -> Filter b -> Filter a
by derived (Filter filter) =
    Filter <| by_ derived filter


by_ : (a -> b) -> (b -> Bool) -> a -> Bool
by_ derived filter item =
    filter <| derived item


{-| Keep items that do pass the filter.
-}
list : Filter a -> List a -> List a
list filter =
    List.filter (test filter)


{-| Run an item through a given filter.
-}
test : Filter a -> a -> Bool
test (Filter filter) item =
    filter item


{-| A filter that always passes.
-}
pass : Filter a
pass =
    Filter pass_


pass_ : a -> Bool
pass_ _ =
    True


{-| A filter that always fails.
-}
fail : Filter a
fail =
    Filter fail_


fail_ : a -> Bool
fail_ _ =
    False


{-| Pass if all filters pass.
-}
all : List (Filter a) -> Filter a
all filters =
    List.foldl and pass filters


{-| Pass if at least one filter passes.
-}
any : List (Filter a) -> Filter a
any filters =
    List.foldl or fail filters


{-| Keep items that pass the filter.
-}
array : Filter a -> Array a -> Array a
array filter =
    Array.filter (test filter)
