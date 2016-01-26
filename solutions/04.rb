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

  def sort(rank = ranks)
    @deck .sort_by! { |item| [suits.index(item.suit), rank.index(item.rank)] }
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
    @hand.sort.each_cons(2) { |pair| return true if is_pair?(pair) }
    return false
  end

  def tierce?
    @hand.sort(ranks).
      each_cons(3) { |cards| return true if is_sequence?(cards) }
    false
  end

  def quarte?
    @hand.sort(ranks).
      each_cons(4) { |cards| return true if is_sequence?(cards) }
    false
  end

  def quint?
    @hand.sort(ranks).
      each_cons(5) { |cards| return true if is_sequence?(cards) }
    false
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

  def is_sequence?(cards)
    return false if cards[1..-1].any? { |card| card.suit != cards[0].suit }
    cards_rank = cards.map { |card| card.rank }
    ranks.each_cons(cards.size).to_a.any? { |sequence| sequence == cards_rank }
  end

  def is_pair?(pair)
    pair[0].suit == pair[1].suit and
      pair[0].rank == :king and
      pair[1].rank == :queen
  end

  def carre_of?(rank)
    @hand.select { |item| item.rank == rank }.size == 4
  end

  def ranks
    [:ace, :king, :queen, :jack, 10, 9, 8, 7]
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
    false
  end

  def forty?(trump_suit)
    @hand.sort.select { |item| item.suit == trump_suit}.
      each_cons(2) { |pair| return true if is_pair?(pair) }
    false
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
