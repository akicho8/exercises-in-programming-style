require "active_record"
require "active_support/core_ext/object/with_options"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "tf.db")

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  with_options if_not_exists: true do
    create_table :documents do |t|
      t.string :name
    end

    create_table :words do |t|
      t.belongs_to :document
      t.string :value
    end

    create_table :characters do |t|
      t.belongs_to :word
      t.string :value
    end
  end
end

class Document < ActiveRecord::Base
  has_many :words, dependent: :destroy

  after_create do
    words.create!(extract_words.collect { |e| { value: e } })
  end

  private

  def extract_words
    stop_words = IO.read("../stop_words.txt").scan(/\w+/)
    words = IO.read(name).downcase.scan(/[a-z]{2,}/)
    words - stop_words
  end
end

class Word < ActiveRecord::Base
  belongs_to :document
  has_many :characters, dependent: :destroy

  after_create do
    characters.insert_all!(value.each_char.collect { |e| { value: e } })
  end
end

class Character < ActiveRecord::Base
  belongs_to :word
end

Document.count                  # => 1
Word.count                      # => 56615
Character.count                 # => 354865

# 
# 0.5s (初回: 22s)

# ActiveSupport::LogSubscriber.colorize_logging = false
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

document = Document.find_or_create_by!(name: "../pride-and-prejudice.txt")
# document = Document.find_or_create_by!(name: "../input.txt")
counts = document.words.group(:value).order(:count_all).reverse_order.limit(25).count
puts counts.collect { |e| e * " - " }
# >> -- create_table(:documents, {:if_not_exists=>true})
# >>    -> 0.0137s
# >> -- create_table(:words, {:if_not_exists=>true})
# >>    -> 0.0002s
# >> -- create_table(:characters, {:if_not_exists=>true})
# >>    -> 0.0001s
# >> mr - 786
# >> elizabeth - 635
# >> very - 488
# >> darcy - 418
# >> such - 395
# >> mrs - 343
# >> much - 329
# >> more - 327
# >> bennet - 323
# >> bingley - 306
# >> jane - 295
# >> miss - 283
# >> one - 275
# >> know - 239
# >> before - 229
# >> herself - 227
# >> though - 226
# >> well - 224
# >> never - 220
# >> sister - 218
# >> soon - 216
# >> think - 211
# >> now - 209
# >> time - 203
# >> good - 201
