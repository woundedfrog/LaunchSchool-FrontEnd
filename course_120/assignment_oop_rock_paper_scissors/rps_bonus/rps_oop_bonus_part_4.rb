class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  COMBOS = {
    'rock' => %w(scissors lizard),
    'paper' => %w(rock spock),
    'scissors' => %w(paper lizard),
    'lizard' => %w(spock paper),
    'spock' => %w(rock scissors)
    }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    COMBOS[@value].include?(other_move.value)
  end

  def to_s
    @value
  end
end

class MoveHistory
  attr_accessor :move_history
  
  def initialize
    @move_history = Hash.new(0)
  end

  def update_history(move)
    move_history[move] += 1
  end
  
  def formated_history
    
  end
end

class Player
  attr_accessor :move, :name, :player_score, :history

  def initialize
    set_name
    @history = MoveHistory.new.move_history #returns a HASH
    @player_score = 0
  end

  def increment_score
    @player_score += 1
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "Please enter your player name!"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, that's not a valid input!"
    end
    self.name = n.capitalize
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice!"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Mr.Bigglesworth", "Timmy"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class GameMessages
  def display_welcome_message
    system 'clear'
    puts "Hello, #{human.name}! Welcome to Rock Paper Scissors!"
  end

  def display_goodbye_message
    puts "Thank you for playing Rock paper Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_round_winner
    if human.move > computer.move
      human.increment_score
      puts "#{human.name} won #{human.player_score}/#{@win_limit} games!".center(80)
      puts "#{computer.name} won #{computer.player_score}/#{@win_limit} rounds!".center(80)
    elsif computer.move > human.move
      computer.increment_score
      puts "#{human.name} won #{human.player_score}/#{@win_limit} games!".center(80)
      puts "#{computer.name} won #{computer.player_score}/#{@win_limit} rounds!".center(80)
    else
      puts "It's a tie!".center(80)
    end
  end

  def game_winner!
    if human.player_score > computer.player_score
      puts "You beat the computer. GREAT!"
    else
      puts "The computer won! LOSER!"
    end
    human.player_score = 0
    computer.player_score = 0
  end
end

class UserPrompts < GameMessages
  def play_again?
    answer = nil
    loop do
      puts "We've reached the end of the game. Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, input must be 'y' or 'n'"
    end

    answer.downcase == 'y' # this returns true or false automatically
  end

  def choose_win_limit
    puts "Please choose a winnings score - (1~10)."
    loop do
      @win_limit = gets.chomp.to_i
      break if @win_limit > 0
      puts "Please enter a valid number!"
    end
    system 'clear'
    puts "Thank you! Let's start."
  end
end

class RPSGame < UserPrompts
  attr_accessor :human, :computer

  def initialize
    system 'clear'
    @human = Human.new
    @computer = Computer.new
    @win_limit = 0
  end

  def play
    display_welcome_message
    choose_win_limit
    round_counter = 0

    loop do
      round_counter += 1
      puts "Round #{round_counter}"
      human.choose
      computer.choose
      display_moves
      display_round_winner
      if (human.player_score >= @win_limit || computer.player_score >= @win_limit)
        game_winner!
        break unless play_again?
        round_counter = 0
      end    
    end
    display_goodbye_message
  end
end

#RPSGame.new.play
x = RPSGame.new
