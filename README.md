# autopluck

Approximately a billion times, students attempt to do something like this:


```ruby
Movie.all.titles
```

or

```ruby
Movie.where({ :director_id => @director.id }).titles
```

or, later on,

```ruby
photo.fans.usernames
```

We then give them the standard lecture about how it doesn't make sense to ask an `Array` for it's `titles`. However, as of some recent version of Rails, it doesn't _look_ like an `Array` in the resulting error message anymore, like it did while I was learning. A cryptic error message instead says that it's an `ActiveRecord::Relation`, which is pretty indistinguishable from a regular ActiveRecord object to a beginner.

Solutions:

 1. We could patch the error message somehow to make it say "undefined method `titles` for an array of `Movie`s".
 2. We could make it work as expected, and return an array of strings.

In this repo, I explore the second option, by monkeypatching [ActiveRecord::Associations::CollectionProxy](https://www.rubydoc.info/docs/rails/3.1.1/ActiveRecord/Associations/CollectionProxy):

```ruby
class ActiveRecord::Associations::CollectionProxy
  def method_missing(message, *args, &block)
    desired_attribute = message.to_s.singularize

    if attribute_names.include?(desired_attribute)
      return pluck(desired_attribute)
    else
      super
    end
  end
end
```

Now one can do:

```
[1] pry(main)> User.first.liked_photos.captions
=> ["Cueva de los Verdes",
 "Sviati Hory",
 "Mostar",
 "Jaipur",
 "Mostar",
 "Elakala",
 "Biandintz",
 "Cueva de los Verdes",
 "Biandintz"]
```

Thoughts? Is this better or worse for learning than patching with a more descriptive error message? (We've talked for years about improving all error message copy; perhaps that's a better general solution.)

 - It adds "magic", but is it any more magic than the rest of ActiveRecord's query methods?
 - The next error message that they'll probably get _will_ be descriptive, because they'll try to loop through a director's movie's to get its year, but they'll obviously only have a string (it's title).
