module Filter exposing (Filter, Status(..), all, and, any, array, by, custom, eq, fail, gt, list, lt, not, or, pass, test, gte, lte, neq)

{-| Useful ways to combine filters (also known as predicates)!

@docs Filter, Status, all, and, any, array, by, custom, eq, fail, gt, list, lt, not, or, pass, test, gte, lte, neq

-}

import Array exposing (Array)


{-| The result of a filter.
-}
type Status
    = Pass
    | Fail


{-| A `Filter` takes a value `a` and determines whether it should pass or fail.
-}
type Filter a
    = Filter (a -> Status)


{-| Test whether a value is less than `num`.
-}
lt : Int -> Filter Int
lt num =
    custom <| lt_ num


lt_ : Int -> Int -> Status
lt_ num item =
    case compare item num of
        LT ->
            Pass

        _ ->
            Fail


{-| Test whether a value is less than or equal to `num`.
-}
lte : Int -> Filter Int
lte num =
    custom <| lte_ num


lte_ : Int -> Int -> Status
lte_ num item =
    case compare item num of
        GT ->
            Fail

        _ ->
            Pass


{-| Test whether a value is greater than `num`.
-}
gt : Int -> Filter Int
gt num =
    custom <| gt_ num


gt_ : Int -> Int -> Status
gt_ num item =
    case compare item num of
        GT ->
            Pass

        _ ->
            Fail


{-| Test whether a value is greater than or equal to `num`.
-}
gte : Int -> Filter Int
gte num =
    custom <| gte_ num


gte_ : Int -> Int -> Status
gte_ num item =
    case compare item num of
        LT ->
            Fail

        _ ->
            Pass


{-| Test whether a value is equal to `ref`.
-}
eq : a -> Filter a
eq ref =
    custom <| eq_ ref


eq_ : a -> a -> Status
eq_ ref item =
    if ref == item then
        Pass

    else
        Fail


{-| Test whether a value is not equal to `ref`.
-}
neq : a -> Filter a
neq ref =
    custom <| neq_ ref


neq_ : a -> a -> Status
neq_ ref item =
    if ref /= item then
        Pass

    else
        Fail


{-| Pass if both filters pass.
-}
and : Filter a -> Filter a -> Filter a
and (Filter left) (Filter right) =
    custom <| and_ left right


and_ : (a -> Status) -> (a -> Status) -> a -> Status
and_ left right item =
    case left item of
        Pass ->
            right item

        _ ->
            Fail


{-| Pass if at least one filter passes.
-}
or : Filter a -> Filter a -> Filter a
or (Filter left) (Filter right) =
    custom <| or_ left right


or_ : (a -> Status) -> (a -> Status) -> a -> Status
or_ left right item =
    case left item of
        Fail ->
            right item

        _ ->
            Pass


{-| Flip the outcome of a filter; if it fails it passes, and if it passes it fails.
-}
not : Filter a -> Filter a
not (Filter filter) =
    custom <| not_ filter


not_ : (a -> Status) -> a -> Status
not_ filter item =
    case filter item of
        Pass ->
            Fail

        Fail ->
            Pass


{-| Sometimes the building blocks in this library aren't enough!
-}
custom : (a -> Status) -> Filter a
custom =
    Filter


{-| Filter a value by a derived property, like its height.

    bob =
        { height = 5 }

    isTall =
        by .height <| gt 6

    test isTall bob
    -- Fail

-}
by : (a -> b) -> Filter b -> Filter a
by derived (Filter filter) =
    Filter <| by_ derived filter


by_ : (a -> b) -> (b -> Status) -> a -> Status
by_ derived filter item =
    filter <| derived item


{-| Keep items that pass the filter.
-}
list : Filter a -> List a -> List a
list filter =
    List.foldr (foldStep filter) []


foldStep : Filter a -> a -> List a -> List a
foldStep filter element rest =
    case test filter element of
        Pass ->
            element :: rest

        Fail ->
            rest


{-| Run an item through a given filter.
-}
test : Filter a -> a -> Status
test (Filter filter) item =
    filter item


{-| A filter that always passes.
-}
pass : Filter a
pass =
    Filter pass_


pass_ : a -> Status
pass_ _ =
    Pass


{-| A filter that always fails.
-}
fail : Filter a
fail =
    custom fail_


fail_ : a -> Status
fail_ _ =
    Fail


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
    Array.fromList << Array.foldr (foldStep filter) []
