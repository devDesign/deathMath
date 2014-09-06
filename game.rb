@game_hash = {}

def welcome 
    @game_hash = {
    random_number1: 0,
    random_number2: 0,
    correct_answer: 0,
    level_counter: 0,
    level_timer_start: Time.now,
    level_timer_end: Time.now,
    level_time_limit: 0,
    player_turn: 0,
    player_1_name: "player 1", 
    player_1_lives: 0,
    player_1_score: 0,
    player_1_frags: 0,
    player_2_name: "player 2",
    player_2_lives: 0,
    player_2_score: 0,
    player_2_frags: 0
  }
  puts "Death Math"
  puts "Player 1 enter your username: "
  @game_hash[:player_1_name] = gets.chomp
  puts "Player 2 enter your username: "
  @game_hash[:player_2_name] = gets.chomp
  new_game
end

def new_game  
  puts "Frag limit : "
  @game_hash[:player_1_lives] = gets.chomp.to_i
  @game_hash[:player_1_start] = @game_hash[:player_1_lives]
  @game_hash[:player_2_lives] = @game_hash[:player_1_lives]
  next_level
end

def whos_turn(level)
  if level % 2 == 0 
    @game_hash[:player_turn] = 2
  else
    @game_hash[:player_turn] = 1
  end
end

def the_question  
  @game_hash[:random_number1] = rand(2 + @game_hash[:level_counter]) + @game_hash[:level_counter]
  @game_hash[:random_number2] = rand(2 + @game_hash[:level_counter]) + @game_hash[:level_counter]
  @game_hash[:correct_answer] = @game_hash[:random_number1] + @game_hash[:random_number2]
end

def next_level
  @game_hash[:level_counter] += 1
  whos_turn(@game_hash[:level_counter])
  the_question
  display_question
  player_attempt
end

def player_attempt
  player_answer = gets.chomp.to_i
  is_correct(player_answer)
end

def is_correct(player_answer)
  timer_end
  if timer_limit > timer
    if player_answer == @game_hash[:correct_answer]    
      display_score
      puts "successful defence of #{@game_hash[:random_number1]} + #{@game_hash[:random_number2]} in #{timer} seconds.."
      next_level
    else
      player_death
    end
  else
  player_death
end
end

def player_death
  if @game_hash[:player_turn] == 1
    if @game_hash[:player_1_lives] > 1
      @game_hash[:player_1_lives] -= 1
      display_score
      puts "#{@game_hash[:player_2_name]} kills #{@game_hash[:player_1_name]}" 
      puts "in #{timer} seconds.."
      next_level
    else
      game_over
    end
  else
    if @game_hash[:player_2_lives] > 1
      @game_hash[:player_2_lives] -= 1
      display_score
      puts "#{@game_hash[:player_1_name]} kills #{@game_hash[:player_1_name]}"
      puts "in #{timer} seconds.."
      next_level
    else
      game_over
    end
  end
end

def game_over
  if @game_hash[:player_turn] == 1
    puts "GAME OVER"
    puts "#{@game_hash[:player_2_name]} wins" 
  else
    puts "GAME OVER"
    puts "#{@game_hash[:player_1_name]} wins"
  end
  puts "NEW GAME Y/N"
  continue = gets.chomp
  welcome if continue == "y"
end    

def timer_limit
  timer_limit = 1.3 + @game_hash[:level_counter] / 5
end

def time_left
  time = timer_limit()-timer()
end

def timer
  time = (@game_hash[:level_timer_end] - @game_hash[:level_timer_start]).round(2)
end

def timer_start
  @game_hash[:level_timer_start] = Time.now.round(2)
end

def timer_end
  @game_hash[:level_timer_end] = Time.now.round(2)
end

def display_question
    puts "Press Enter when ready"
  if @game_hash[:player_turn] == 1
    puts "#{@game_hash[:player_1_name]}"
    puts "#{timer_limit} seconds"
  else
    puts "#{@game_hash[:player_2_name]}" 
    puts "#{timer_limit} seconds" 
  end
  gets.chomp
  timer_start
  puts "#{@game_hash[:random_number1]} + #{@game_hash[:random_number2]} = ???"
  player_attempt
end

def display_score
  points = ((100 / timer) * @game_hash[:level_counter]).round(2)
  if @game_hash[:level_counter] % 2 == 0
    @game_hash[:player_2_score] += points
  else
    @game_hash[:player_1_score] += points
  end
  player_1_points = @game_hash[:player_1_score]
  player_2_points = @game_hash[:player_2_score]
  player_2_frags = @game_hash[:player_1_start] - @game_hash[:player_1_lives]  
  player_1_frags = @game_hash[:player_1_start] - @game_hash[:player_2_lives] 
  @game_hash[:player_1_frags] = player_1_frags
  @game_hash[:player_2_frags] = player_2_frags
  puts "#{@game_hash[:player_1_name]}"
  puts "frags: #{player_1_frags}  rating: #{player_1_points}"
  puts "#{@game_hash[:player_2_name]}" 
  puts "frags: #{player_2_frags}  rating: #{player_2_points}"
  puts "LEVEL: #{@game_hash[:level_counter]} FRAGLIMIT: #{@game_hash[:player_1_start]}"
  puts 
end

welcome