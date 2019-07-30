**ActiveSupport::Concern**

This shouldn't be here, because the ItemsController is pretty obviously a **controller**. Including `ActiveSupport::Concern` easily allows you to include that module as a mixin in another class using a syntax like `include Emailable`. Concerns are used like that to share methods between classes or to abstract business logic. I can't imagine anyone doing this with a controller.

**#index**

Converting the result of the item array to an array with `to_a` doesn't accomplish anything, and actually will prevent us from being able to use any Active Record Result methods, like model associations, in the view. 

**#show**

I've seen people using Raw SQL instead of Active Record queries in extremely old legacy code but I think it's fair to assume we don't have to do that anymore.

I took out the `.order(name: :asc)` because typically searching by ID should only return a single record. 

Changed the `@@` to `@` because that is how instance variables are passed by the controller to the view, two at signs would only used for class-level variables in PORO's or Concerns. 

**#create**

Calling `Item.new` and then updating the attributes would create a new object, it would probably fail validation because it wouldn't generate an ID. 

**#update**

Using `.update` instead of `.update_attributes` means that if saving the changes to the database fail, or if model validations fail, then that result will be returned in the `@item` variable. Using `update_attributes` will just turn false.

**#destroy**

The difficult with fixing this method is that we want to delete all of the attachments on the item when the item is deleted, but the scope on the `has_many` attachments means that a dependent destroy there will only be called on the active attachments. 

What I did was rename the default scope for attachments to `active_attachments`, and then put dependent destroy on attachments so that all of the attachments would be destroyed automatically when the parent item was destroyed. 

This will however require going through the rest of the hypothetical codebase and changing `@item.attachments` to `@item.active_attachments` in a few places.

Also, we want to use destroy instead of delete, because delete will skip model callbacks. 

**#user_comments**

The default behavior here is using .map to iterate over every item... Then, querying individually for that item's comments... Then flattening the resulting two-dimensional array, which is so inefficient that it's pretty funny.

Using Ruby lambdas instead of Active Record methods, like I mentioned in #index, though possible, is usually a bad idea becuase it's usually both easier and faster to just use Active Record.

Because the method is named user_comments, it looks like all we need to do is select the comments for a single user... So we can just query for that directly.

**Other Changes**

Just to repeat, This will however require going through the rest of the hypothetical codebase and changing `@item.attachments` to `@item.active_attachments` in a few places.

Normally, there are redirects in controller methods that will redirect the user to the page they were on if their input failed to pass validation and shows them a flash message indicating what happened, so we might want to put that in. 
