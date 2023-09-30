# filter
Replace your boolean logic with [filters](https://package.elm-lang.org/packages/red-g/filter/latest/Filter)!

# why should I use this package?
1. Composability
   * it is easy and elegant to build complex `Filter`s from smaller ones
2. Consistency
   * no special boolean syntax--no `if then else` or short-circuiting operators--everything is normal elm code

# context
Elm is a very small language. Everything sort of "syncs" together in a really nice way.
But amongst all this cohesion, the `Bool` type always stood out to me.
It is a custom type like any other--if you peeked at the source code you would see:
```elm
type Bool = True | False
```
But when working with `Bool` values, unlike *every other custom type*, we don't use `case` expressions.
Instead, `Bool` values demand an if-then-else block, a functionally equivalent expression.
The operators for booleans also seemed out of place--`&&` and `||` are short-circuiting operators,
a common and helpful feature in most programming languages, but nonetheless atypical for an elm operator,
especially considering such lazy behavior could be acheived (albeit more verbosely) with nested `case` expressions.

In short, `Bool` values broke the rules of elm. *A lot*.
And the thing is, good Elm code makes limited use of `Bool`s anyways!
## big problems with booleans
A few years ago, I built a database in Elm. The database provided around 10 different filters you could customize.
But it turns out that combining all those filters together, especially when any of them might be missing, was a *massive pain*.
I learned an important lesson--Elm predicates do not scale well!

Elm types like `Decoder`s, `Task`s, `Parser`s and many more all provided these really nice way to combine smaller pieces together in a very declarative way.
So after tinkering around for a while, I came up a with a solution inspired by all those nice libraries (though much rougher around the edges)--a composable `Filter` type.
It worked really well!

This library is a refined version of that idea, for times when you might need something similar.
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
