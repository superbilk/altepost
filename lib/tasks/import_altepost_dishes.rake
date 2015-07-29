namespace :import_altepost_dishes do
  require 'altepost_parser'

  desc "imports all dishes of the current day"
  task today: :environment do
    altepost = AltepostParser.new
    dishes = altepost.dishes_of_today
    dishes.each do |dish|
      unless dish[:image_file].nil?
        File.open(Rails.public_path.join('images', "#{dish[:meal_id]}.jpg"), "w") do |f|
          f.write(File.open(dish[:image_file], 'r').read)
        end
      end
      dish.delete(:image_file)
      new_dish = Dish.find_or_initialize_by(meal_id: dish[:meal_id])
      new_dish.update_attributes(dish)
      puts "NEW DISH: #{dish[:meal_id]} - #{dish[:date]} - #{dish[:name]}"
      puts "SAVED: #{new_dish.save!}"
    end
  end

  desc "imports all dishes of a specific day"
  task :by_date, [:date] => [:environment] do |t, args|
    args.with_defaults(:date => Date.today.strftime('%d.%m.%Y'))
    altepost = AltepostParser.new
    dishes = altepost.dishes_of_the_day(args.date)
    dishes.each do |dish|
      unless dish[:image_file].nil?
        File.open(Rails.public_path.join('images', "#{dish[:meal_id]}.jpg"), "w") do |f|
          f.write(File.open(dish[:image_file], 'r').read)
        end
      end
      dish.delete(:image_file)
      new_dish = Dish.find_or_initialize_by(meal_id: dish[:meal_id])
      puts "SAVED: #{new_dish.update_attributes(dish)}"
      puts "NEW DISH: #{dish[:meal_id]} - #{dish[:date]} - #{dish[:name]}"
    end
  end

  desc "imports all dishes of a specific month"
  task :by_month, [:month] => [:environment] do |t, args|
    args.with_defaults(:month => Date.today.strftime('%m/%Y'))
    altepost = AltepostParser.new
    Date.parse(args.month).beginning_of_month.upto(Date.parse(args.month).end_of_month) do |day|
      dishes = altepost.dishes_of_the_day(day.strftime('%d.%m.%Y'))
      dishes.each do |dish|
        unless dish[:image_file].nil?
          File.open(Rails.public_path.join('images', "#{dish[:meal_id]}.jpg"), "w") do |f|
            f.write(File.open(dish[:image_file], 'r').read)
          end
        end
        dish.delete(:image_file)
        new_dish = Dish.find_or_initialize_by(meal_id: dish[:meal_id])
        puts "SAVED: #{new_dish.update_attributes(dish)}"
        puts "NEW DISH: #{dish[:meal_id]} - #{dish[:date]} - #{dish[:name]}"
      end
    end
  end
end
