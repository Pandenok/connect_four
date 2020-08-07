module Display
  def display_name_prompt(player_number)
    "What's the name for Player #{player_number}? "
  end

  def display_move_prompt
    "\n#{players[current_player_idx].name.capitalize}, please drop your disk in one of the columns: "
  end

  def display_notice_column_full
    "This column is full, please choose one with empty slots"
  end

  def display_welcome_intro
    <<~HEREDOC
    Welcome to Connect Four!

    (also known as Four Up, Plot Four, Find Four,
    Four in a Row, Four in a Line, Drop Four, 
    and Gravitrips in the Soviet Union).

    HEREDOC
  end

  def display_game_rules
    <<~HEREDOC
    
    Please read the rules of the game:
    
    The two players alternate turns dropping one of their discs at a time into an unfilled column.
    The pieces fall straight down, occupying the lowest available space within the column.
    The objective of the game is to be the first to form a horizontal, vertical, or diagonal line of four of one's own discs.
    If the board fills up before either player achieves four in a row, then the game is a draw. 
    
    Here is your board...

    HEREDOC
  end

  def display_input_error
    "This move is not valid, please try again"
  end

  def display_congratulations
    "#{players[current_player_idx].name.capitalize} is a winner today!"
  end

  def display_tie
    "#{players[current_player_idx].name.capitalize} and #{players[next_player].name}, You both are invincible!"
  end

  def display_restart_game_prompt
    "One more round?"
  end

  def display_farewell
    "Thank you and have a nice day!"
  end
end