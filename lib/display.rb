module Display
  def display_name_prompt(player_number)
    "What's the name for Player #{player_number}? "
  end

  def display_move_prompt
    "\n#{players[current_player_idx].name.capitalize}, please drop your disk #{players[current_player_idx].token} in one of the columns: "
  end

  def display_notice_column_full
    "This column is full, please choose one with empty slots"
  end

  def display_welcome_intro
    system 'clear'
    <<~HEREDOC

                Welcome to 
    ┌─┐┌─┐┌┐┌┌┐┌┌─┐┌─┐┌┬┐  ┌─┐┌─┐┬ ┬┬─┐
    │  │ │││││││├┤ │   │   ├┤ │ ││ │├┬┘
    └─┘└─┘┘└┘┘└┘└─┘└─┘ ┴   └  └─┘└─┘┴└─

    HEREDOC
  end

  def display_game_rules
    <<~HEREDOC

    #{players[current_player_idx].name.capitalize} and #{players[next_player].name.capitalize}!

    The rules are simple: try to build a row of four checkers 
    while keeping your opponent from doing the same. The four 
    in a row can be horizontal, vertical or diagonal. If the 
    board fills up before either player achieves four in a row, 
    then the game is a draw. Sounds easy, but it's not! 
    Ready to get started?!

    Here is your board...
    HEREDOC
end

  def display_input_error
    "This move is not valid, please try again"
  end

  def display_congratulations
    "\n#{players[current_player_idx].name.capitalize} is a winner today!"
  end

  def display_tie
    "\n#{players[current_player_idx].name.capitalize} and #{players[next_player].name.capitalize}, You both are invincible!"
  end

  def display_restart_game_prompt
    "One more round?"
  end

  def display_farewell
    "Thank you and have a nice day!"
  end
end