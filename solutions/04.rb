class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other)
    @rank == other.rank && @suit == other.suit
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.to_s.capitalize}"
  end
end

class Deck
  include Enumerable

  @@suits = [:spades, :hearts, :diamonds, :clubs]

  def initialize(deck)
    @deck = deck
  end

  def each
    @deck.each { |item| yield item }
  end

  def size
    @deck.size
  end

  def draw_top_card
    @deck.delete_at(0)
  end

  def draw_bottom_card
    @deck.delete_at(-1)
  end

  def top_card
    @deck[0]
  end

  def bottom_card
    @deck[-1]
  end

  def shuffle
    @deck.shuffle!
  end

  def to_s
    @deck.join("\n")
  end
end

class WarDeck < Deck
  @@ranks = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]

  def initialize(deck = base_deck)
    super
  end

  def deal
    WarHand.new(@deck.pop(26))
  end

  def sort
    @deck.sort! { |first, second| base_deck.index(first) <=>
                  base_deck.index(second) }
  end

  private

  def base_deck
    @@suits.product(@@ranks).map { |item| Card.new(*item.reverse) }
  end
end

class WarHand
  def initialize(hand)
    @hand = WarDeck.new(hand)
  end

  def size
    @hand.size
  end

  def play_card
    @hand.draw_top_card
  end

  def allow_face_up?
    @hand.size <= 3
  end
end

class BeloteDeck < Deck
  @@ranks = [:ace, 10, :king, :queen, :jack, 9, 8, 7]

  def initialize(deck = base_deck)
    super
  end

  def deal
    BeloteHand.new(@deck.pop(8))
  end

  def sort
    @deck.sort! { |first, second| base_deck.index(first) <=>
                  base_deck.index(second) }
  end

  private

  def base_deck
    @@suits.product(@@ranks).map { |item| Card.new(*item.reverse) }
  end
end

class BeloteHand
  @@suits = [:spades, :hearts, :diamonds, :clubs]
  @@ranks = [:ace, :king, :queen, :jack, 10, 9, 8, 7]

  def initialize(hand)
    @hand = BeloteDeck.new(hand)
  end
  def size
    @hand.size
  end

  def base_sequence
    @@suits.product(@@ranks).map { |item| Card.new(*item.reverse) }
  end

  def suit_sequence(suit)
    [suit].product(@@ranks).map { |item| Card.new(*item.reverse) }
  end

  def highest_of_suit(suit)
    @hand.sort.select { |item| item.suit == suit }[0]
  end

  def belote?
    @@suits.reduce(false) do |result, suit|
      result or
      @hand.select { |card| card.rank == :king or card.rank == :queen }.
        select { |card| card.suit == suit }.size == 2
    end
  end

  def tierce?
  end

  def quarte?
  end

  def quint?
  end

  def carre_of_jacks?
    @hand.select { |item| item.rank == :jack }.szie == 4
  end

  def carre_of_nines?
    @hand.select { |item| item.rank == 9 }.szie == 4
  end

  def carre_of_aces?
    @hand.select { |item| item.rank == :ace }.size == 4
  end

  def to_s
    @hand.to_s
  end
end

class SixtySixDeck < Deck
  @@ranks = [:ace, 10, :king, :queen, :jack, 9]

  def initialize(deck = base_deck)
    super
  end

  def deal
    SixtySixHand.new(@deck.pop(6))
  end

  def sort
    @deck.sort! { |first, second| base_deck.index(first) <=>
                  base_deck.index(second) }
  end

  private

  def base_deck
    @@suits.product(@@ranks).map { |item| Card.new(*item.reverse) }
  end
end

class SixtySixHand
  def initialize(hand)
    @hand = SixtySixDeck.new(hand)
  end

  def twenty?(trump_suit)
    @hand.sort.select { |card| card.suit != trump_suit }.
      each_cons(2) { |cards| return true if cards[0].rank == :king and
                     cards[1].rank == :queen }
    return false
  end

  def forty?(trump_suit)
    @hand.sort.select { |card| card.suit == trump_suit }.
      select { |card| card.rank == :king or card.rank == :queen }.size == 2
  end

  def size
    @hand.size
  end
end
