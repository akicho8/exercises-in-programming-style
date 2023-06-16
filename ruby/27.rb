class Column
  attr_accessor :values

  def initialize(&formula)
    @formula = formula
    @values = []
  end

  def update
    if @formula
      @values = @formula.call
    end
  end
end

all_words      = Column.new
stop_words     = Column.new
non_stop_words = Column.new { all_words.values.collect { |e| stop_words.values.include?(e) ? nil : e } }
unique_words   = Column.new { non_stop_words.values.compact.uniq }
counts         = Column.new { unique_words.values.collect { |e| non_stop_words.values.count(e) } }
sorted_data    = Column.new { unique_words.values.zip(counts.values).sort_by { -_2 } }

all_columns = { all_words:, stop_words:, non_stop_words:, unique_words:, counts:, sorted_data: }

update = -> { all_columns.values.each(&:update) }

all_words.values = IO.read("../pride-and-prejudice.txt").downcase.scan(/[a-z]{2,}/)
stop_words.values = IO.read("../stop_words.txt").scan(/\w+/)
update.call
puts sorted_data.values.take(25).collect { |e| e * " - " }

require "table_format"
all_words.values = %w(a b c bar b c foo c)
stop_words.values = %w(foo bar)
update.call
tp all_words.values.each_index.collect { |i|
  all_columns.inject({}) { |a, (k, v)| a.merge(k => v.values[i]) }
}
