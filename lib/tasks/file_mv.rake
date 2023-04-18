task file_mv: :environment do
  puts 'file_mv'

  Dir.open('app') do |file|
    puts file
  end

  puts 'a_init_province_and_cities end'
end
