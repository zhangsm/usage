class Book < Struct.new(:title)
  def words
    @words ||= self.title.gsub(/[a-zA-Z]{3,}/).map(&:downcase).uniq.sort  # "Ruby programming language" --> ["language", "programming", "ruby"]
  end
end


class BookRecommender
  def initialize book, books
    @book, @books = book, books
  end

  def recommendations
    @books.map! do |this_book|
      this_book.define_singleton_method(:jaccard_index) do @jaccard_index;  end
      this_book.define_singleton_method("jaccard_index=") do |index|
        @jaccard_index = index || 0.0
      end
      intersection = (@book.words & this_book.words).size
      union = (@book.words | this_book.words).size
      this_book.jaccard_index = (intersection.to_f / union.to_f) rescue 0.0
      this_book
    end.sort_by { |book| 1 - book.jaccard_index }  # 排序
  end
end


BOOKS = DATA.read.split("\n").map { |l| Book.new(l) }

this_book = Book.new("Ruby programming language")

recommender = BookRecommender.new(this_book, BOOKS)

recommended_books = recommender.recommendations

# Show books that match the most
recommended_books.each do |book|
  puts "#{book.title} (Jaccard : #{'%.2f' % book.jaccard_index})"
end


__END__
Finding the best language for the job
Could Ruby save the day
Python will rock your world
Is Ruby better than Python
Programming in Ruby is fun
Python to the moon
Programming languages of the future
