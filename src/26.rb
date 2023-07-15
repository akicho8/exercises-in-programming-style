## データ中心 ##

### 26. データベース - SQL ###

# とりあえず全部DBに入れておく

#+BEGIN_SRC
require "active_record"
require "active_support/core_ext/object/with_options"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "_tf.db")
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
    stop_words = IO.read("stop_words.txt").scan(/\w+/)
    words = IO.read(name).downcase.scan(/[a-z]{2,}/)
    words - stop_words
  end
end

class Word < ActiveRecord::Base
  belongs_to :document
  has_many :characters, dependent: :destroy

  scope :frequency, -> { group(:value).order(:count_all).reverse_order }

  after_create do
    characters.insert_all!(value.chars.collect { |e| { value: e } })
  end
end

class Character < ActiveRecord::Base
  belongs_to :word
end

document = Document.find_or_create_by!(name: "pride-and-prejudice.txt")
Document.count                  # => 1
Word.count                      # => 56615
Character.count                 # => 354865
puts document.words.frequency.limit(25).count.collect { |e| e * " - " }
#+END_SRC

# 富豪的で好き。初回だけめっちゃ時間かかる。
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
