# filter
Elm library for manipulating filters.

# examples
Implementing a greater-than-or-equals `Filter` through composition:
```elm
gte : Int -> Filter Int
gte num =
  Filter.or Filter.eq (Filter.gt num)

Filter.test (gte 3) 3
-- True

Filter.test (gte 4) 5
-- True

Filter.test (gte 1) -1
-- False
```

Ensuring that one of a list of conditions is passed:
```elm
myLongFilter : Filter Thing
myLongFilter =
  Filter.any [ thingIsGreen, thingIsWide, thingIsHeavy ]

Filter.list myLongFilter [ greenThing, yellowThing, wideThing, lightThing, heavyThing ]
-- [ greenThing, wideThing, heavyThing ]
```