Rails Decal Lecture 6 Demo: Welp
================================

In this lecture, we will be recreating Yelp, the popular restaurant reviews site! The goals of this demo are to review everything you've learned in the class so far:
- Model-View-Controller & CRUD
- Routes: Resources Routing
- Migrations
- `form_for`
- `belongs_to` and `has_many` associations
- Validations
- Strong Params
- Devise

Let's get started!

## Getting Started
Create your application by running `rails new welp` in the directory of your choice and `cd welp`. You will not need to run `bundle install` because making a new app will automatically do this for you.

Verify you've set things up correctly by starting up the `rails server`.

## Models
What models will we be needing for this application?

**Restaurant**
```
name:string
address:string
```
**Review**
```
content:text
rating:integer
user_id:integer
restaurant_id:integer
```
**User**
```
first_name:string
last_name:string
```

Use `$ rails generate model [model_name] [attribute_name]:[attribute_type]` to create the **Restaurant** and **Review** models. Remember, that models should be *singular*. Don't forget to run `$ rails db:migrate` afterwards.

## Devise
We still have to make a `User` model and want the functionality of being able to have users log in and log out of our application. A common way to do this in Rails is through the [Devise authentication library](https://github.com/plataformatec/devise).

To set up devise, add the line `gem 'devise'` to your `Gemfile` and run `bundle install`. Next, install devise with the command `$ rails generate devise:install`.

Finally, we can generate models set up with devise with the command: `$ rails generate devise [model_name]`.

After saving these changes via `rails db:migrate`, let's create the routes and views so users can sign in. Luckily, devise handles all of this for us.

If you inspect `config/routes.rb`, you will notice a new line that has been added after we generated our User model - `devise_for :users`. Run `rails routes` to see exactly what routes are added from this line. All that's left to create are the views which we can do with `$ rails generate devise:views`. much magic \o/ rails is gr8

Now if we go to `localhost:3000/users/sign_up`, we can create an account and log in.

## Associations

Consider the kinds of associations we have in our application. Restaurants have many reviews and a review belongs to a user and a restuarant. Additionally, since each review is tied to one user, a user can have many reviews.

We already have the foreign keys we need but we still need to explicitly specify the association types in our models. Once this is done properly, you can now access variables like `user.reviews` or `review.user` or `restaurant.reviews`.

There is one last thing we have to do. Add indices on our foreign keys. While your app will function properly without them, indices will optimize queries on our database! If you take CS 186 in the future, you'll get to learn all about why this is important and how this works. But for now, know you can add indices by generating a migration with `$ rails g migration AddIndices` and modifying the change method as follows:

```
def change
    add_index :reviews, :user_id
    add_index :reviews, :restaurant_id
end
```

## Validations
Let's make sure we don't have reviews with empty content and no ratings. Add the validation to ensure `content` and `rating` are present when you create a review.

## Controllers
Now that we have our models, let's give our app the functionality we need. We want to:
- Show all restaurants
- Show a restaurant and its reviews
- Show all users
- Show a user profile and all their reviews
- Post a new review

### Show all restaurants
Let's start by showing a list of all restaurants and making this our root page.

Generate a `RestaurantsController` with the `index` method. Next, modify the associated view to display a list of all the restaurant names and set the root path to `restaurants#index`.

Let's also add a couple of restaurants to our database in `rails console` to verify this works.

### Show a restaurant and its reviews
Now let's give our `RestaurantsController` a `show` method so we may have a page to view one restaurant and it's reviews. To create a route with a `id` param for the restaurant id, you can define it as:

```
get '/restaurants/:id', to: 'restaurants#show', as: 'restaurant'
```
This will also give your route the prefix 'restaurant' so it can referenced with the variable `restaurant_path(@restaurant)`

Once you have the method, view, and route, you should be able to visit `localhost:3000/restaurants/1`. Again, let's create some reviews in `rails console`. Remember that reviews are required to have both an associated `restaurant_id` and `user_id`, in addition to non-nil `content` and `rating` attributes.

Lastly, let's turn the restaurant names on our home page into links by replacing the line that render the name to:

```
<%= link_to r.name, restaurant_path(r) %>
```
Click the link and see that your reviews show up.

### Show all users/Show a user profile and all their reviews

This is really similar to the what we just did but for users. Try this out on your own.

### Post a new review

Lastly, we should have a form under each restaurant page so a user can post a review for it.

**ReviewsController**
First, generate `ReviewsController` with a `create` method that will take the form data we pass in to create a new review for that restaurant.

Let's try defining the private `review_params` method so we can mass update `content` and `rating` when we recieve it from the form. Remember in your `create` method to also set the review's restaurant to what is given by `Restaurant.find(params[:id])` and the review's user to `current_user`. `current_user` is a convience variable given to us by devise to get the currently logged in user. For now, we won't worry about what happens when a user is not logged in, this will be left as an extra exercise.

Save the review object you just created and `redirect_to` the restaurant page at the end of this method.

**Route**

Let's create a `POST` route for the form to visit when it is submitted. We will want the route to be for `restaurants/:id` and this should go to `reviews#create`. This allows us to have the restaurant id when we get `params[:id]` so we can set the review's restaurant to be the id of the restaurant's page we are on.

**form_for**

Finally, in the show page for each restaurant, we will want to add a form at the end to create a new review.

We can use `form_for` to help us. This will require us to also declare a variable `@review = Review.new` in `restaurants#show`

Then, we can add the form as follows in *views/restaurants/show.html.erb*:

```
<h2> Post a Review </h2>

<%= form_for @review, url: restaurant_path(@restaurant) do |f| %>
	Content: <%= f.text_area :content %>
	<br />
	Rating: <%= f.number_field :rating %>
	<br />
	<%= f.submit %>
<% end %>
```
Notice how we explicitly specify that the url this form should POST to once it is submitted is `restaurant_path(@restaurant)` because of how our route was set up in the section above.

## Fin
Yay! You have reached the end of this demo walkthrough :) I hope this gives you a better sense of how all the pieces we've discussed in lecture come together. You can now apply many of the methods we used to start building your own applications!

Lastly, keep in mind, the code here is specific to how we wanted this application to be set up so if you want to customize your application to do anything else, some googling will be required to find the right helpers that will suit your needs. Good luck!
