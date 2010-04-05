ActiveRecord::Schema.define(:version => 0) do
  create_table :person, :force => true do |t|
    t.string :name
    t.date :raise
  end
end