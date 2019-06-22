require 'faker'

clothing_collection = Clothing.create!(name: "Clothing and Apparel")
outdoor_collection = Outdoor.create!(name: "Outdoor Gear")
book_collection = Book.create(name: "Books")

5.times do
  book_collection.products.create!(name: Faker::Lorem.sentence(3))
end

book_products = Product.joins(:collections).where('collections.type == "Book"')

3.times do
  outdoor_collection.products.create!(name: Faker::Lorem.sentence(2))
end

outdoor_products = Product.joins(:collections).where('collections.type == "Outdoor"')

2.times do
  book_products.sample.collections << outdoor_collection
end

2.times do
  clothing_collection.products.create!(name: Faker::Lorem.sentence(1))
end

3.times do
  outdoor_products.sample.collections << clothing_collection
end

# use first variant for testing purposes
Variant.create!(
  name: Faker::Color.color_name,
  cost: Faker::Number.number(rand(1..3)),
  stock_amount: 100,
  weight: Faker::Number.decimal(rand(1..2), 2),
  product_id: 1
)

Product.all.each do |product|
  rand(1..4).times do
    Variant.create!(
      name: Faker::Color.color_name,
      cost: Faker::Number.number(rand(1..3)),
      stock_amount: Faker::Number.number(rand(1..3)),
      weight: Faker::Number.decimal(rand(1..2), 2),
      product: product
    )
  end
end

10.times do
  Customer.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email
  )
end

puts "-"*50
puts "Seeding Finished"
puts "#{Collection.count} collections created"
puts "#{Product.count} products created"
puts "#{Variant.count} variants created"
puts "#{Customer.count} customers created"
