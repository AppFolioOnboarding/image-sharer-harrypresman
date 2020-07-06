class AddTagDataToOldRecords < ActiveRecord::Migration[5.2]
  def up
    now = Time.now.strftime('%Y-%m-%d %H:%M:%S.%6N')
    create_default_tag now
    associate_default_tag_with_tagless_images now
  end

  def down
    execute "DELETE FROM taggings WHERE tag_id='#{default_tag_id}';"
    execute "DELETE FROM tags WHERE name='#{default_tag_name}';"
  end

  private

  def default_tag_name
    'default'
  end

  def default_tag_id
    default_tag_record = execute "SELECT id FROM tags WHERE name='#{default_tag_name}';"
    default_tag_record.first['id']
  end

  def create_default_tag(timestamp)
    execute  <<-SQL
      INSERT INTO tags (name, created_at, updated_at)
      VALUES ('#{default_tag_name}', '#{timestamp}', '#{timestamp}');
    SQL
  end

  def associate_default_tag_with_tagless_images(timestamp)
    cached_tag_id = default_tag_id
    tagless_images = execute 'SELECT id FROM images WHERE id NOT IN (SELECT taggable_id FROM taggings);'
    tagless_images.each do |image|
      image_id = image['id']
      execute <<-SQL
        INSERT INTO taggings (tag_id, taggable_type, taggable_id, context, created_at)
        VALUES ('#{cached_tag_id}', 'Image', '#{image_id}', 'tags', '#{timestamp}')
      SQL
      execute "UPDATE tags SET taggings_count=taggings_count+1 WHERE name='#{default_tag_name}';"
    end
  end
end
