images = []
20.times { images << 'https://source.unsplash.com/random' }
images.each do |url|
  Image.create!(url: url, tag_list: 'seeded image')
end
