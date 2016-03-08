![Gitten badge](http://gittens.r15.railsrumble.com//badge/jphager2/mangdown)

There is a simple built-in client, "M", that you can use for finding manga:

```ruby
require 'mangdown/client'

# Search for an exact match
results = M.find("Dragon Ball")

# Or if you need more flexibilty when searching for a manga, 
# use are Regex
results = M.find(/dragon ball(\ssd)?$/i)

# Get a Mangdown::Manga object
manga = results.first.to_manga

# Get a chapter count
manga.count

# Download everything
manga.download

# Download a specific range 
manga.download(0, 99)

# Convert all downloaded chapters to CBZ
manga.cbz

```
