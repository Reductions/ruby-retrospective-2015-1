class Integer < Numeric

  def prime?
    number = self.to_i
    return true if number == 2
    return false if number < 2 or number % 2 == 0
    divisor = 3
    while divisor * divisor <= number
      return false if number % divisor == 0
      divisor += 2
    end
    return true
  end

end

class FibonacciSequence

  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    index, current, following = 0, @first, @second
    while index < @limit
      yield current
      index += 1
      current, following = succeed(current, following)
    end
  end

  def succeed(current, following)
    return following, current + following
  end
end

class PrimeSequence

  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    return if @limit <= 0
    yield 2
    index, current = 1, 3
    while index < @limit
      yield current
      index, current = index + 1, next_prime_after(current)
    end
  end

  def next_prime_after(current)
    candidate = current + 2
    until candidate.prime?
      candidate += 2
    end
    candidate
  end

end

class RationalSequence

  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    index, numerator, denominator = 0, 1, 1
    while index < @limit
      yield Rational(numerator, denominator)
      index += 1
      numerator, denominator = succeed(numerator, denominator)
    end
  end

  def succeed(numerator, denominator)
    numerator, denominator = iterate(numerator, denominator)
    until numerator.gcd(denominator) == 1
      return numerator, 1 if denominator == 0
      return 1, denominator if numerator == 0
      numerator, denominator = iterate(numerator, denominator)
    end
    return numerator, denominator
  end

  def iterate(numerator, denominator)
    first = numerator + (-1)**(numerator + denominator)
    second = denominator + (-1)**(numerator + denominator + 1)
    return first, second
  end

end

module DrunkenMathematician

  module_function

  def meaningless(limit)
    RationalSequence.new(limit).reduce(1.to_r) do |product, item|
      if non_prime_component?(item)
        product / item
      else
        product * item
      end
    end
  end

  def aimless(limit)
    PrimeSequence.new(limit).each_slice(2).map { |item| Rational(*item) }.reduce(0.to_r,:+)
  end

  def worthless(limit)
    return [] if limit == 0
    the_number = FibonacciSequence.new(limit).to_a[limit - 1]
    RationalSequence.new(2*the_number).take_while do |item|
      the_number -= item
      the_number >= 0
    end
  end

  def non_prime_component?(rational)
    not (rational.numerator.prime? or rational.denominator.prime?)
  end

end
