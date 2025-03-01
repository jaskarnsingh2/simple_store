require 'faker'
require 'csv'

# Clear existing data
Product.destroy_all
Category.destroy_all

# Read the CSV file
csv_file = Rails.root.join('db/products.csv')
csv_data = File.read(csv_file)

products = CSV.parse(csv_data, headers: true)

# Load products from CSV and create them
products.each do |row|
  product_name = row['name']
  product_price = row['price']
  product_description = row['description']&.strip  # Strip any extra spaces
  product_stock = row['stock quantity']&.strip.to_i  # Strip any extra spaces and convert to integer
  product_category = row['category']&.strip  # Strip any extra spaces

  # Ensure the category is not empty
  if product_category.blank?
    puts "Warning: Product '#{product_name}' has no category, skipping."
    next  # Skip this product if no category is provided
  end

  # Find or create the category
  category = Category.find_or_create_by(name: product_category)

  # Log the data to check if everything is correct
  puts "CSV Product: #{product_name}, Description: #{product_description}, Stock: #{product_stock}, Category: #{product_category}"

  # Create the product using data from CSV (No Faker if description and stock are available)
  Product.create(
    title: product_name,          # Use the product name from the CSV
    description: product_description,  # Use the description from the CSV
    price: product_price,         # Use the price from the CSV
    stock_quantity: product_stock,  # Use the stock quantity from the CSV
    category: category             # Use the existing category
  )
end

# Now, create additional fake products to meet the requirement of 676 products
required_product_count = 676
existing_product_count = Product.count
additional_product_count = required_product_count - existing_product_count

# Generate fake products if necessary
if additional_product_count > 0
  additional_product_count.times do
    # Create a random category using Faker if you want fake categories as well
    category_name = Faker::Commerce.department
    category = Category.find_or_create_by(name: category_name)

    # Generate fake product data
    Product.create(
      title: Faker::Commerce.product_name,        # Fake product name
      description: Faker::Lorem.sentence,          # Fake description
      price: Faker::Commerce.price,                # Fake price
      stock_quantity: Faker::Number.between(from: 1, to: 100),  # Fake stock quantity
      category: category                           # Use the random category
    )
  end
end
