class DashboardController < ApplicationController

  def index
    # @users = User.first(10)
    @users_7 = User.where(created_at: (Time.now - 7.day)..Time.now).count
    @users_30 = User.where(created_at: (Time.now - 30.day)..Time.now).count
    @users_100 = User.where(created_at: (Time.now - 100.day)..Time.now).count

    @orders_7 = Order.where(checkout_date: (Time.now - 7.day)..Time.now).count
    @orders_30 = Order.where(checkout_date: (Time.now - 30.day)..Time.now).count
    @orders_100 = Order.where(checkout_date: (Time.now - 100000.day)..Time.now).count

    # @products_7 = Product.where(checkout_date: (Time.now - 7.day)..Time.now).count
    # @products_30 = Product.where(checkout_date: (Time.now - 30.day)..Time.now).count
    # @products_100 = Product.where(checkout_date: (Time.now - 100000.day)..Time.now).count

    @top_three_state = User.find_by_sql ("SELECT states.name, COUNT(states.name) 
      FROM users JOIN addresses ON (users.id=user_id) 
      JOIN states ON (state_id = states.id) 
      GROUP BY states.name ORDER BY COUNT(states.name) desc LIMIT 3")
    @top_three_city = User.find_by_sql ("SELECT cities.name, COUNT(cities.name) 
      FROM users JOIN addresses ON (users.id=user_id) 
      JOIN cities ON (city_id=cities.id) 
      GROUP BY cities.name ORDER BY COUNT(cities.name) desc LIMIT 3")
  end

end

#User that has spent the most in one order
User.find_by_sql ("SELECT users.first_name, orders.id, (order_contents.quantity*products.price) AS total 
  FROM users JOIN orders ON (users.id=user_id) 
  JOIN order_contents ON (orders.id=order_id) 
  JOIN products ON (product_id=products.id)
  GROUP BY total, users.first_name, orders.id
  ORDER BY total desc")

# life-time value HOLY FUCK THAT TOOK LONG
User.find_by_sql ("SELECT users.first_name, orders.id, SUM((order_contents.quantity*products.price)) AS total 
  FROM users JOIN orders ON (users.id=user_id) 
  JOIN order_contents ON (orders.id=order_id) 
  JOIN products ON (product_id=products.id)
  GROUP BY users.first_name, orders.id
  ORDER BY total desc")

#User that has the highest average order 
User.find_by_sql ("SELECT users.first_name, orders.id, AVG((order_contents.quantity*products.price)) AS total 
  FROM users JOIN orders ON (users.id=user_id) 
  JOIN order_contents ON (orders.id=order_id) 
  JOIN products ON (product_id=products.id)
  GROUP BY users.first_name, orders.id
  ORDER BY total desc")

#User that has the most orders placed in their life-time
User.find_by_sql ("SELECT users.first_name, COUNT(orders.id) AS TotalOrders
  FROM users JOIN orders ON (users.id=user_id) 
  JOIN order_contents ON (orders.id=order_id)
  GROUP BY users.first_name
  ORDER BY users.first_name") 





# User.find_by_sql ("SELECT * FROM users ")
# User.find_by_sql ("SELECT * FROM users JOIN addresses ON (users.id=user_id) JOIN states ON (state_id = states.id)")
# User.find_by_sql ("SELECT cities.name, COUNT(cities.name) FROM users JOIN addresses ON (users.id=user_id) JOIN cities ON (city_id = cities.id) GROUP BY city.name ORDER BY COUNT(city.name) desc")