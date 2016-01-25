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
    current, sequent = @first, @second
    (0...@limit).each do
      yield current
      current, sequent = sequent, current + sequent
    end
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
    current = 1
    (1...@limit).each do
      current = next_prime_after(current)
      yield current
    end
  end

  private

  def next_prime_after(current)
    candidate = current + 2
    candidate += 2 until candidate.prime?
    candidate
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    numerator, denominator = 1, 1
    (0...@limit).each do
      yield Rational(numerator, denominator)
      numerator, denominator = succeed(numerator, denominator)
    end
  end

  private

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
  extend self

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
    PrimeSequence.new(limit).each_slice(2)
      .map { |item| Rational(*item) }.reduce(0.to_r,:+)
  end

  def worthless(limit)
    return [] if limit == 0
    the_number = FibonacciSequence.new(limit).to_a[-1]
    RationalSequence.new(2 * the_number).
      take_while { |item| (the_number -= item) >= 0 }
  end

private

  def self.non_prime_component?(rational)
    not (rational.numerator.prime? or rational.denominator.prime?)
  end
end
