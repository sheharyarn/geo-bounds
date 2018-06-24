GeoBounds
=========

> Experiments with Axis-aligned Bounding Boxes in Elixir


## Start

```bash
$ mix deps.get
$ mix compile
$ iex -S mix
```


## Usage

The application exports two struct definitions, `Location` and `BoundedBox`
which represent a geo-coordinate location and an axis-aligned bounded box,
respectively.

```elixir
# Construct new location from long, lat
nyc     = Location.new(-74.0060, 40.7128)
philly  = Location.new(-75.1652, 39.9526)
trenton = Location.new(-74.7597, 40.2206)
jersey  = Location.new(-74.0776, 40.7282)
chicago = Location.new(-87.6298, 41.8781)

# Construct a Bounding Box from two coordinates
box = BoundedBox.new(nyc, philly)

# Check if a location resides inside the bounding box
BoundedBox.inside?(box, trenton)      # => true
BoundedBox.inside?(box, jersey)       # => false
BoundedBox.inside?(box, chicago)      # => false
```

Two GenServers are also started as part of the application supervision tree;
`BoxServer` and `PointMatcher`. BoxServer acts as a data-store for bounding
boxes, allowing you to add new boxes to it using `add/1`, and later find the
box which contains a given point using `find/1`.

```elixir
# Add some points to the BoxServer
BoxServer.add(BoundedBox.new({0, 2},  {2, 0}))
BoxServer.add(BoundedBox.new({4, 6},  {6, 4}))
BoxServer.add(BoundedBox.new({8, 10}, {10, 8}))

# Find a box for given points
BoxServer.find(Location.new(1, 1))    # => %BoundedBox{...}
BoxServer.find(Location.new(2, 2))    # => %BoundedBox{...}
BoxServer.find(Location.new(3, 3))    # => nil
```


`PointMatcher` acts as a higher level layer, by building on top of the
`BoxServer`. You can match a single point or a pair of `origin, destination`
points using `match/1` or `match/2`. If a box exists that contains a given
point, it will store a reference to the `BoundedBox` against the point and
return the value, otherwise it will simply discard the point returning `nil`.
You can get a list of all matched points using `list/0`.

Finally, there is a `Parser` helper module that adds and matches location
points stored in the `priv/data/` directory.

```elixir
# Populate BoxServer with an initial list of bounding boxes
# in `pairs.csv`
Parser.read_pairs!


# Read all location points in `coordinates.csv` and match
# them against the previously created bounding boxes
Parser.match_points!


# Get a list of all points and their matching boxes
PointMatcher.list


# Match boxes for another pair of points
origin      = Location.new(120.9724, 14.7462)
destination = Location.new(120.8917, 14.6364)

PointMatcher.match(origin, destination)
# => [ %BoundedBox{...}, nil ]
```
