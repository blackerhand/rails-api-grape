task file_mv: :environment do
  map_dir(Rails.root.join('app_1'))
end

def map_dir(dir)
  dir.children.each do |file|
    next if file.to_s == '.' || file.to_s == '..'

    if File.file?(file)
      FileUtils.mv(file, Rails.root.join('app_2'))
    else
      map_dir(file)
    end
  end
end
