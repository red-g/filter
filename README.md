# filter
[Elm library](https://package.elm-lang.org/packages/red-g/filter/latest/Filter) for manipulating filters.

# examples
Implementing a greater-than-or-equals `Filter` through composition:
```elm
gte : Int -> Filter Int
gte num =
  Filter.or Filter.eq (Filter.gt num)

Filter.test (gte 3) 3
-- Pass

Filter.test (gte 4) 5
-- Pass

Filter.test (gte 1) -1
-- Fail
```

Ensuring that one of a list of conditions is passed:
```elm
myLongFilter : Filter Thing
myLongFilter =
  Filter.any [ thingIsGreen, thingIsWide, thingIsHeavy ]

Filter.list myLongFilter [ greenThing, yellowThing, wideThing, lightThing, heavyThing ]
-- [ greenThing, wideThing, heavyThing ]
```