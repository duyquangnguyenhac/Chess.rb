class Game
  attr_reader :board, :white_player, :black_player, :cur_player

  def initialize(board:, white_player:, black_player:)
    @board = board
    @white_player = white_player
    @black_player = black_player
    @cur_player = white_player
  end

  def play
    loop do
      turn
      switch_cur_player
      board_check
    end    
  end

  private

  def turn
    display_board
    puts "It's your turn, #{player_name}!"
    loop do
      response = get_player_response
      if response == 'help'
        help
      elsif response == 'save'
        save
      elsif response == 'quit'
        quit
      elsif response == 'resign'
        resign
      else
        new_board = process_messages(response)
        update_board(new_board)
        break
      end
    end
  end

  def board_check
    if checkmate?(team)
      puts "Checkmate!"
      display_board
      switch_cur_player
      victory
    elsif stalemate?(team)
      puts "Stalemate!"
      display_board
      draw
    end
    puts "Check!" if check?(team)
  end

  def switch_cur_player
    @cur_player = (cur_player == black_player ? white_player : black_player)
  end

  def display_board
    board.display(team)
  end

  def update_board(new_board)
    @board = new_board
  end

  def process_messages(response)
    response.messages.each { |message| puts message }
    response.clear_messages
  end
  
  def team
    cur_player.team
  end

  def player_name
    cur_player.name
  end

  def get_player_response
    cur_player.play(board)
  end

  def help
    puts <<~INSTRUCTIONS
      To move one of your pieces, please type the name of the piece followed by the name 
      of the square you want to move it to, for example 'knight to c3'. 
      If you want to move a pawn, you can also just type the name of the square you want to move it to, like 'e4'.
      
      You can also enter any of the following at any time:
      - enter 'resign' to resign
      - enter 'save' to save the game you're playing
      - enter 'quit' to stop playing
      - enter 'help' to see these instructions again.
    INSTRUCTIONS
  end

  def save
    puts "Enter a filename so you can retrieve your saved game later:"
    filename = gets.chomp.downcase
    File.open("./saved_games/#{filename}.yml", "w") do |file|
      file.write(YAML.dump(self))
    end
    puts "Game saved."
  end

  def quit
    puts "Make sure to save your game if you want to come back to it later!"
    puts "Are you sure you want to exit the game (y/n)?"
    input = gets.chomp.downcase
    loop do
      if input == 'y'
        exit
      elsif input == 'n'
        break
      else
        puts "Please enter 'y' to exit or 'n' to go back"
        input = gets.chomp.downcase
      end
    end    
  end

  def resign
    puts "Are you sure you want to resign from the game (y/n)?"
    input = gets.chomp.downcase
    loop do
      if input == 'y'
        switch_cur_player
        victory
      elsif input =='n'
        break
      else
        puts "Please enter 'y' to resign or 'n' to go back"
        input = gets.chomp.downcase
      end
    end
  end

  def victory
    puts "#{player_name} wins! Thanks for playing."
    exit
  end

  def draw
    puts "It's a draw! Thanks for playing."
    exit
  end

  def check?(team)
    board.check?(team)
  end

  def checkmate?(team)
    board.checkmate?(team)
  end

  def stalemate?(team)
    board.stalemate?(team)
  end
end