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

  def sort
    @deck .sort_by! { |item| [suits.index(item.suit), ranks.index(item.rank)] }
  end

  def to_s
    @deck.join("\n")
  end

  private

  def base_deck
    suits.product(ranks).map { |item| Card.new(*item.reverse) }
  end

  def suits
    [:spades, :hearts, :diamonds, :clubs]
  end
end

class WarDeck < Deck
  def initialize(deck = base_deck)
    super
  end

  def deal
    WarHand.new(@deck.pop(26))
  end

  private

  def ranks
    [:ace, :king, :queen, :jack, *(10.downto(2))]
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
  def initialize(deck = base_deck)
    super
  end

  def deal
    BeloteHand.new(@deck.pop(8))
  end

  private

  def ranks
    [:ace, 10, :king, :queen, :jack, 9, 8, 7]
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
    carre_of?(:jack)
  end

  def carre_of_nines?
    carre_of?(9)
  end

  def carre_of_aces?
    carre_of?(:ace)
  end

  private

  def carre_of?(rank)
    @hand.select { |item| item.rank == rank }.size == 4
  end
end

class SixtySixDeck < Deck
  def initialize(deck = base_deck)
    super
  end

  def deal
    SixtySixHand.new(@deck.pop(6))
  end

  private

  def ranks
    [:ace, 10, :king, :queen, :jack, 9]
  end
end

class SixtySixHand
  def initialize(hand)
    @hand = SixtySixDeck.new(hand)
  end

  def twenty?(trump_suit)
    @hand.sort.select { |item| item.suit != trump_suit }.
      each_cons(2) { |pair| return true if is_pair?(pair) }
    return false
  end

  def forty?(trump_suit)
    @hand.sort.select { |item| item.suit == trump_suit}.
      each_cons(2) { |pair| return true if is_pair?(pair) }
    return false
  end

  def size
    @hand.size
  end

  private

  def is_pair?(pair)
    pair[0].suit == pair[1].suit and
      pair[0].rank == :king and
      pair[1].rank == :queen
  end
end
