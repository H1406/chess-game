require 'gosu'

WIDTH = 1000
HEIGHT = 800
CELL_DIM = 100

PAWN_VALUE = 10
KNIGHT_VALUE = 30
BISHOP_VALUE = 30
ROOK_VALUE =50
QUEEN_VALUE = 90
PAWN_TABLE=[
  [100,100,100,100,100,100,100,100],
  [90,90,90,90,90,90,90,90],
  [30,30,10,30,30,30,30,30],
  [10,10,40,60,60,40,10,10],
  [10,10,40,60,60,40,10,10],
  [30,30,30,50,50,30,30,30],
  [90,90,90,90,90,90,90,90],
  [100,100,100,100,100,100,100,100]
]
KNIGHT_TABLE = [
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 40, 40, 0, 0, 0],
  [0, 0, 60, 0, 0, 60, 0, 0],
  [0, 0, 0, 50, 50, 0, 0, 0],
  [0, 0, 0, 50, 50, 0, 0, 0],
  [0, 0, 60, 0, 0, 60, 0, 0],
  [0, 0, 0, 40, 40, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0]
]
BISHOP_TABLE = [
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 60, 0, 30, 30, 0, 60, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 60, 0, 30, 30, 0, 60, 0],
  [0, 0, 0, 0, 0, 0, 0, 0]
]
ROOK_TABLE = [
  [0, 0, 0, 70, 70, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 70, 70, 0, 0, 0]
]
QUEEN_TABLE = [
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0]
]
KING_TABLE = [
  [0, 0, 100, 0, 0, 0, 100, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 100, 0, 0, 0, 100, 0]
]

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class Cell
  attr_accessor :x,:y,:color
  def initialize
    @x
    @y
    @color = "GRAY"
  end
end

class Main < Gosu::Window
  def initialize  
    super WIDTH,HEIGHT
    self.caption = "Chess Game"
    @font = Gosu::Font.new(40)
    @capture_sound = Gosu::Sample.new("./sounds/capture.mp3")
    column_index = 0 
    @check = false
    @turn = "white"
    @es_passant = false
    @max_piece 
    dark = true
    @winner = ''
    @holding = false
    @last_pos = []
    @last_piece
    @all_piece_move=[]
    @last_white_locations=[]
    @last_black_locations=[]
    @last_white_pieces = []
    @last_black_pieces = []
    @check_mate = false
    # Tracking king and rook movements
    @white_king_moved = false
    @black_king_moved = false
    @white_rook_left_moved = false
    @white_rook_right_moved = false
    @black_rook_left_moved = false
    @black_rook_right_moved = false
    @temp_pieces
    @temp_locations
    @to_delete = []
    @pos_move = []
    @black = []
    @white = []
    @current_piece
    @all_pos_move = []
    @columns = Array.new(8)
    @black_queen = Gosu::Image.new("black_pieces/bq.png")
    @black_king = Gosu::Image.new("black_pieces/bk.png")
    @black_rook = Gosu::Image.new("black_pieces/br.png")
    @black_knight = Gosu::Image.new("black_pieces/bn.png")
    @black_bishop = Gosu::Image.new("black_pieces/bb.png")
    @black_pawn = Gosu::Image.new("black_pieces/bp.png")
    @black << @black_rook
    @black << @black_knight
    @black << @black_bishop
    @black << @black_queen
    @black << @black_king
    @black << @black_pawn
    @white_queen = Gosu::Image.new("white_pieces/wq.png")
    @white_king = Gosu::Image.new("white_pieces/wk.png")
    @white_rook = Gosu::Image.new("white_pieces/wr.png")
    @white_knight = Gosu::Image.new("white_pieces/wn.png")
    @white_bishop = Gosu::Image.new("white_pieces/wb.png")
    @white_pawn = Gosu::Image.new("white_pieces/wp.png")
    @white << @white_rook
    @white << @white_knight
    @white << @white_bishop
    @white << @white_queen
    @white << @white_king
    @white << @white_pawn
    @pieces_list = ["rook","knight","bishop","queen","king","pawn"]
    while column_index < 8
      row_index = 0
      dark = !dark
      row = Array.new(8)
      @columns[column_index] = row
      while row_index < 8
        cell = Cell.new
        cell.x = column_index
        cell.y = row_index
        if dark
          cell.color = "GREEN"
          dark = false
        else
          cell.color = "GRAY"
          dark = true
        end
        @columns[column_index][row_index] = cell
        row_index+=1
      end
      column_index+=1
    end
    @white_pieces = ["rook","knight","bishop","king","queen","bishop","knight","rook","pawn","pawn","pawn","pawn","pawn","pawn","pawn","pawn"]
    @white_locations = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]
    @black_pieces = ["rook","knight","bishop","king","queen","bishop","knight","rook","pawn","pawn","pawn","pawn","pawn","pawn","pawn","pawn"]
    @black_locations =  [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7],[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]
    @white_king_color = "GREEN"
    @black_king_color = "GRAY"
  end

  def draw_board
    @columns.each do |column|
      column.each do |row|
        case row.color
        when "GRAY"
          Gosu.draw_rect(row.x*CELL_DIM,row.y*CELL_DIM,CELL_DIM,CELL_DIM,Gosu::Color.argb(0xff_eeeed2),ZOrder::BACKGROUND)
        when "GREEN"
          Gosu.draw_rect(row.x*CELL_DIM,row.y*CELL_DIM,CELL_DIM,CELL_DIM,Gosu::Color.argb(0xff_769656), ZOrder::BACKGROUND)
        end       
      end
    end
  end

  def draw_bg
    Gosu.draw_rect(0,0,WIDTH,HEIGHT,Gosu::Color::WHITE,ZOrder::BACKGROUND,mode=:default)
    Gosu.draw_rect(850,50,100,50,Gosu::Color::BLACK,ZOrder::BACKGROUND,mode=:default)
    @font.draw_text("Reset",855,55,ZOrder::MIDDLE,1.0,1.0,Gosu::Color::WHITE,mode=:default)
    Gosu.draw_rect(850,150,100,50,Gosu::Color::BLACK,ZOrder::BACKGROUND,mode=:default)
    @font.draw_text("Undo",855,155,ZOrder::MIDDLE,1.0,1.0,Gosu::Color::WHITE,mode=:default)
  end 

  def draw_pieces
  # Drawing black pieces
    (0...@black_pieces.size).each do |i|
      case @black_pieces[i]
      when "rook"
        @black_rook.draw((@black_locations[i][0] * CELL_DIM) + 5, @black_locations[i][1] * CELL_DIM ,ZOrder::TOP,0.6,0.6)
      when "knight"
        @black_knight.draw((@black_locations[i][0] * CELL_DIM) +5 , @black_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "bishop"
        @black_bishop.draw((@black_locations[i][0] * CELL_DIM) +5 ,  @black_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "queen"
        @black_queen.draw((@black_locations[i][0] * CELL_DIM) +5 , @black_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "king"
        @black_king.draw((@black_locations[i][0] * CELL_DIM) +5, @black_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "pawn"
        @black_pawn.draw((@black_locations[i][0] * CELL_DIM) +5 , @black_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      end
    end
    (0...@white_pieces.size).each do |i|
      case @white_pieces[i]
      when "rook"
        @white_rook.draw((@white_locations[i][0] * CELL_DIM) + 5, @white_locations[i][1] * CELL_DIM ,ZOrder::TOP,0.6,0.6)
      when "knight"
        @white_knight.draw((@white_locations[i][0] * CELL_DIM) +5 , @white_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "bishop"
        @white_bishop.draw((@white_locations[i][0] * CELL_DIM) +5 ,  @white_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "queen"
        @white_queen.draw((@white_locations[i][0] * CELL_DIM) +5 , @white_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "king"
        @white_king.draw((@white_locations[i][0] * CELL_DIM) +5, @white_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      when "pawn"
        @white_pawn.draw((@white_locations[i][0] * CELL_DIM) +5 , @white_locations[i][1] * CELL_DIM , ZOrder::TOP,0.6,0.6)
      end
    end
  end

  def draw
    draw_bg
    draw_board
    draw_pieces
    draw_pos_move
  end

  def check_option(piece,location)
    move_list = []
    case piece
    when  "pawn"
      move_list = check_pawn(location)
    when "rook"
      move_list = check_rook(location)
    when "knight"
      move_list = check_knight(location)
    when "bishop"
      move_list = check_bishop(location)
    when "queen"
      move_list = check_queen(location)   
    when "king"
      move_list = check_king(location)
    end
    return move_list
  end
  def check_all_option(pieces,locations)
    move_list = []
    all_move_list = []
    pieces.each do |piece|
      location = locations[pieces.index(piece)]
      case piece
      when  "pawn"
        move_list = check_pawn(location)
      when "rook"
        move_list = check_rook(location)
      when "knight"
        move_list = check_knight(location)
      when "bishop"
        move_list = check_bishop(location)
      when "queen"
        move_list = check_queen(location)   
      when "king"
        move_list = check_king(location)
      end
      all_move_list += move_list
    end
    return all_move_list
  end

  def check_all_piece(pieces,locations)
    move_list = []
    all_piece = []
    pieces.each do |piece|
      location = locations[pieces.index(piece)]
      #puts move_list
      move_list = nil
      case piece
      when  "pawn"
        move_list = check_pawn(location)
      when "rook"
        move_list = check_rook(location)
      when "knight"
        move_list = check_knight(location)
      when "bishop"
        move_list = check_bishop(location)
      when "queen"
        move_list = check_queen(location)   
      when "king"
        move_list = check_king(location)
      end
      for i in (0..(move_list.length() -1))
        all_piece << location
      end
    end
    return all_piece
  end

  def check_king(position)
    move_list = []
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
    end
    targets = [ [1,0],[0,1],[1,-1],[-1,1],[0,-1],[1,1],[-1,-1],[-1,0]]
    for i in (0..7) do 
      target = [position[0]+ targets[i][0],position[1] + targets[i][1]]
      if !friend_list.include?(target) and target[0].between?(0,7) and target[1].between?(0,7)
        move_list << target
      end
    end
    return move_list
  end
  def check_pawn(position)
    move_list = []
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
      target1 = [position[0],position[1]+1]
      target2 = [position[0],position[1]+2]
      target_left= [position[0]-1,position[1]+1]
      target_right = [position[0]+1,position[1]+1]
      if !enemy_list.include?(target1) and !friend_list.include?(target1) and target1[1] <6
        move_list << target1
      end
      if !enemy_list.include?(target2) and !friend_list.include?(target2) and position[1]==1 and !friend_list.include?(target1)
        move_list << target2
      end
      if enemy_list.include?(target_right)
        move_list << target_right
      end
      if enemy_list.include?(target_left)
        move_list << target_left
      end
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
      target1 = [position[0],position[1]-1]
      target2 = [position[0],position[1]-2]
      target_left= [position[0]-1,position[1]-1]
      target_right = [position[0]+1,position[1]-1]
      if !enemy_list.include?(target1) and !friend_list.include?(target1) and target1[1] > 1
        move_list << target1
      end
      if !enemy_list.include?(target2) and !friend_list.include?(target2) and position[1]==6 and !friend_list.include?(target1)
        move_list << target2
      end
      if enemy_list.include?(target_right)
        move_list << target_right
      end
      if enemy_list.include?(target_left)
        move_list << target_left
      end
    end
    return move_list
  end
  def check_queen(position)
    move_list = []
    second_move_list = []
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
    end
    move_list = check_bishop(position)
    second_move_list = check_rook(position)
    move_list += second_move_list
    return move_list
  end
  def check_bishop(position)
    move_list=[]
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
    end
    for i in (0..3) do  # up-right, up-left, down-right, down-left
      path = true
      chain = 1
      case i
      when  0 
          x = 1
          y = -1
      when  1
          x = -1
          y = -1
      when 2
          x = 1
          y = 1
      when 3
          x = -1
          y = 1
      end
      while path
        target = [position[0]+ (chain * x),position[1] + (chain*y)]
        if !friend_list.include?(target) and target[0].between?(0,7) and target[1].between?(0,7) 
          move_list << target
          if enemy_list.include?(target)
            path = false
          end
          chain+=1
        else 
          path = false
        end
      end
    end
    return move_list
  end
  def check_rook(position)
    move_list=[]
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
    end
    for i in (0..3) do  # up-right, up-left, down-right, down-left
      path = true
      chain = 1
      case i
      when  0 
          x = 1
          y = 0
      when  1
          x = -1
          y = 0
      when  2
          x = 0
          y = 1
      when 3
          x = 0
          y = -1
      end
      while path
        target = [position[0]+ (chain * x),position[1] + (chain*y)]
        if !friend_list.include?(target) and target[0].between?(0,7) and target[1].between?(0,7) 
          move_list << target
          if enemy_list.include?(target) 
            path = false
          end
          chain+=1
        else 
          path = false
        end
      end
    end
    return move_list
  end
  def check_knight(position)
    move_list=[]
    if @turn == "white"
      friend_list = @white_locations
      enemy_list = @black_locations
    elsif @turn == "black"
      enemy_list = @white_locations
      friend_list = @black_locations
    end
    for i in (0..7)do
      case i 
      when 0
        x = 2
        y=1
      when 1
        x=2
        y=-1
      when 2
        x=-2
        y=1
      when 3
        x =-2
        y=-1
      when 4
        x=1
        y=2
      when 5 
        x=-1
        y=2
      when 6
        x=1
        y=-2
      when 7
        x=-1
        y=-2
      end
      target = [position[0]+ x,position[1] + y]
      if !friend_list.include?(target) and target[0].between?(0,7) and target[1].between?(0,7)
        move_list << target
      end
    end
    return move_list
  end
  def capture()
    if @turn == "white"
      @white_locations.each do |location|
        if @black_locations.include?(location)
          @capture_sound.play
          captured_index = @black_locations.index(location)
          if @black_pieces[captured_index]=='king'
            @winner = @turn
          else
          if location == [0,7] and @black_pieces[captured_index] =='rook'
            @black_rook_left_moved = true
          elsif location == [7,7] and @black_pieces[captured_index] =='rook'
            @black_rook_right_moved = true
          end
          @black_pieces.delete_at(captured_index)
          @black_locations.delete_at(captured_index)
          end
        end
      end
    elsif @turn == "black"
      @black_locations.each do |location|
        if @white_locations.include?(location)
          captured_index = @white_locations.index(location)
          @capture_sound.play
          if @white_pieces[captured_index] == 'king'
            @winner = @turn
          else
            if location == [0,0] and @white_pieces[captured_index] =='rook'
              @whiterook_left_moved = true
            elsif location == [7,0] and @white_pieces[captured_index] =='rook'
              @white_rook_right_moved = true
            end
            @white_pieces.delete_at(captured_index)
            @white_locations.delete_at(captured_index)
          end
        end
      end
    end
  end
  def draw_pos_move
    if @pos_move 
      @pos_move.each do |move|
        Gosu.draw_rect(move[0]*CELL_DIM,move[1]*CELL_DIM,CELL_DIM,CELL_DIM,Gosu::Color.rgba(255, 0, 0, 128),ZOrder::MIDDLE)
      end
    end
    if @check
      if @turn =='white'
        Gosu.draw_rect(@white_locations[@white_pieces.index('king')][0]*CELL_DIM,@white_locations[@white_pieces.index('king')][1]*CELL_DIM,CELL_DIM,CELL_DIM,Gosu::Color.rgba(255, 0, 0, 128),ZOrder::MIDDLE) 
      elsif @turn == 'black'
        Gosu.draw_rect(@black_locations[@black_pieces.index('king')][0]*CELL_DIM,@black_locations[@black_pieces.index('king')][1]*CELL_DIM,CELL_DIM,CELL_DIM,Gosu::Color.rgba(255, 0, 0, 128),ZOrder::MIDDLE) 
      end
    end
  end
  def mouse_over_piece()
    if !@check_mate
    x = (mouse_x / CELL_DIM).floor
    y = (mouse_y / CELL_DIM).floor
    mouse_pos = [x, y] 
    if @holding == false
      if @turn == "white"
        if @white_locations.include?(mouse_pos)
          piece = @white_pieces[@white_locations.index(mouse_pos)]
          @current_piece = @white_locations.index(mouse_pos)
          @pos_move = check_option(piece, mouse_pos)
          if @current_piece == @white_pieces.index('king') && can_castle?( "king")
            @pos_move << [1,0]
          end
          if @current_piece == @white_pieces.index('king') && can_castle?( "queen")
            @pos_move << [5,0]
          end
          if @white_pieces[@white_locations.index(mouse_pos)] =='pawn' and @es_passant and @last_pos[1] == 6 and y == 4 and (x ==@last_pos[0]+1 or x == @last_pos[0]-1)
            @pos_move << [@last_pos[0],5]
          end
          check_valid_moves(@pos_move)
          @holding = true
        end
      elsif @turn == "black"
        if @black_locations.include?(mouse_pos)
          piece = @black_pieces[@black_locations.index(mouse_pos)]
          @pos_move = check_option(piece, mouse_pos)
          @current_piece = @black_locations.index(mouse_pos)
          if @current_piece == @black_pieces.index('king') && can_castle?("king")
            @pos_move << [1,7]
          end
          if @current_piece == @black_pieces.index('king')&& can_castle?( "queen")
            @pos_move << [5,7]
          end
          if piece =='pawn' and @es_passant and @last_pos[1] == 1 and y ==3 and (x ==@last_pos[0]+1 or x == @last_pos[0]-1)
            @pos_move << [@last_pos[0],2]
          end
          check_valid_moves(@pos_move)
          @holding = true 
        end
      end
    elsif @holding == true
      @last_black_locations << @black_locations.dup if @turn == 'black'
      @last_black_pieces << @black_pieces.dup if @turn =='black'
      @last_white_locations << @white_locations.dup if @turn =='white'
      @last_white_pieces << @white_pieces.dup if @turn =='white'
      if @pos_move.include?(mouse_pos)
        if @white_pieces[@current_piece] == 'king' or @black_pieces[@current_piece]=='king'
          @white_king_moved = true if @turn == "white"
          @black_king_moved = true if @turn == "black"
        elsif @white_pieces[@current_piece] == 'rook' or @black_pieces[@current_piece]=='rook'
          @white_rook_left_moved = true if @turn == "white"
          @black_rook_left_moved = true if @turn == "black"
          @white_rook_right_moved = true if @turn == "white" 
          @black_rook_right_moved = true if @turn == "black" 
        end
        if @turn == "white"
          if @es_passant and @pos_move.include?([@last_pos[0],5]) and mouse_pos == [@last_pos[0],5]
            if @black_locations.include?([mouse_pos[0],4])
              @black_pieces.delete_at(@black_locations.index([mouse_pos[0],4]))
              @black_locations.delete([mouse_pos[0],4])
              @capture_sound.play
              @last_pos = nil
              @es_passant = false
            end
          end
          @last_pos = @white_locations[@current_piece]
          
          if  @white_pieces[@current_piece] == 'king' and (mouse_pos==[1,0] or mouse_pos==[5,0])
            castling_move('king') if mouse_pos==[1,0]
            castling_move('queen') if mouse_pos == [5,0]
          else
            @white_locations[@current_piece] = mouse_pos
            capture()
            king_check()          
            @es_passant = can_es_passant?()
            @turn = "black"
          end
          random_move()
          @holding = false
        elsif @turn == "black"
          if @es_passant and @pos_move.include?([@last_pos[0],2]) and mouse_pos == [@last_pos[0],2]
            if @white_locations.include?([mouse_pos[0],mouse_pos[1]+1])
              @white_pieces.delete_at(@white_locations.index([mouse_pos[0],mouse_pos[1]+1]))
              @white_locations.delete([mouse_pos[0],mouse_pos[1]+1])
              @capture_sound.play
              @last_pos = nil
              @es_passant = false
            end
          end
          @last_pos = @black_locations[@current_piece]         
          if (mouse_pos == [1,7] or mouse_pos == [5,7]) and @black_pieces[@current_piece] == 'king'
            castling_move('king') if mouse_pos==[1,7]
            castling_move('queen') if mouse_pos == [5,7]
          else
            @black_locations[@current_piece] = mouse_pos
            capture()
            king_check()
            @es_passant = can_es_passant?()
            @turn = "white"
          end
          #random_move()
          @holding = false  
        end
        @pos_move = nil
      else
        # If the player clicks on an invalid position, release the piece without moving
        @holding = false
        @pos_move = nil
        @es_passant = false
        @last_pos = nil
      end
    end
    end
  end
  def can_es_passant?
    if @white_pieces[@current_piece]=='pawn' and @turn == 'white'
      @last_piece = @current_piece
      return true
    elsif @black_pieces[@current_piece] == 'pawn' and @turn =='black'
      @last_piece= @current_piece
      return true
    end
    return false
  end
  def castling_move(side)
    if @turn == "white" && side == "king"
      # King-side castling for white
      @white_locations[@white_pieces.index('king')] = [1, 0]  # King moves two squares to the left
      @white_locations[0] = [2, 0]  # Rook moves next to the king
      @turn = 'black'
    elsif @turn == "white" && side == "queen"
      # Queen-side castling for white
      @white_locations[@white_pieces.index('king')] = [5, 0]  # King moves two squares to the right
      @white_locations[@white_locations.index[7,0]] = [4, 0]  # Rook moves next to the king
      @turn = 'black'
    elsif @turn == "black" && side == "king"
      # King-side castling for black
      @black_locations[@black_pieces.index('king')] = [1,7]  # King moves two squares to the left
      @black_locations[@black_locations.index([0,7])] = [2, 7]  # Rook moves next to the king
      @turn = 'white'
    elsif @turn == "black" && side == "queen"
      # Queen-side castling for black
      @black_locations[@black_pieces.index('king')] = [5, 7]  # King moves two squares to the right
      @black_locations[@black_locations.index([7,7])] = [4, 7]  # Rook moves next to the king
      @turn = 'white'
    end
    @holding = false
  end
  def king_check()
    if @turn == "white"
      king_index = @black_pieces.index('king')
      king_location = @black_locations[king_index]
      @all_pos_move = check_all_option(@white_pieces,@white_locations)
      if @all_pos_move.include?(king_location)
        @check = true
      else @check = false
      end
    elsif @turn == "black"
      king_index = @white_pieces.index('king')
      king_location = @white_locations[king_index]
      @all_pos_move = check_all_option(@black_pieces,@black_locations)
      if @all_pos_move.include?(king_location)
        @check = true
      else 
        @check = false
      end
    end
  end
  def can_castle?(side)
    if @turn == 'white'
      return false if @white_king_moved
      if side =='king'
        return false unless @white_locations.include?([0,0])
        return false if @white_rook_left_moved
        return false unless (@white_locations.include?([1,0]) == false) and ((@white_locations.include?([2,0]) == false))
        return false if @check == true or @all_pos_move.include?([1,0]) or @all_pos_move.include?([2,0])
      elsif side == 'queen'
        return false unless @white_locations.include?([7,0])
        return false if @white_rook_right_moved
        return false unless @white_locations.include?([5,0]) == false and @white_locations.include?([6,0])==false and @white_locations.include?([4,0])
        return false if @check == true or @all_pos_move.include?([4,0]) or @all_pos_move.include?([5,0]) or @all_pos_move.include?([6,0])
      end
    elsif @turn == "black"
      return false if @black_king_moved
      if side == 'king'
        return false if @black_rook_left_moved
        return false unless (@black_locations.include?([1,7]) == false) and ((@black_locations.include?([2,7]) == false))
        return false if @check == true or @all_pos_move.include?([1,7]) or @all_pos_move.include?([2,7])
      elsif side == 'queen'
        return false if @black_rook_right_moved
        return false unless @black_locations.include?([5,7]) == false and @black_locations.include?([6,7])==false and @black_locations.include?([4,7])
        return false if @check == true or @all_pos_move.include?([4,7]) or @all_pos_move.include?([5,7]) or @all_pos_move.include?([6,7])
      end
    end
    return true
  end
  def undo_move()  
    if @last_white_locations.length > 0
      @white_pieces = @last_white_pieces[-1].dup
      @white_locations = @last_white_locations[-1].dup
      @last_white_locations.delete_at(-1)
      @last_white_pieces.delete_at(-1)
      if @last_white_locations.length ==0
        @turn = 'white'
      end
    end
    if @last_black_locations.length > 0 
      @black_locations = @last_black_locations[-1].dup
      @black_pieces = @last_black_pieces[-1].dup
      @last_black_locations.delete_at(-1)
      @last_black_pieces.delete_at(-1)
    end
    if @last_white_locations.length > @last_black_locations.length
      @turn == 'black'
    end
  end
  def button_down(id)
    case id
    when Gosu::MsLeft
      if mouse_x >= 850 and mouse_x <= 950 and mouse_y > 50 and mouse_y < 100
        @white_pieces = ["rook","knight","bishop","king","queen","bishop","knight","rook","pawn","pawn","pawn","pawn","pawn","pawn","pawn","pawn"]
        @white_locations = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1]]
        @black_pieces = ["rook","knight","bishop","king","queen","bishop","knight","rook","pawn","pawn","pawn","pawn","pawn","pawn","pawn","pawn"]
        @black_locations =  [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7],[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6]]
        @turn = 'white'
        @check_mate = false
        @check = false
        @white_king_moved = false
        @black_king_moved = false
        @white_rook_left_moved = false
        @white_rook_right_moved = false
        @black_rook_left_moved = false
        @black_rook_right_moved = false     
      end
      if mouse_x >= 850 and mouse_x <= 950 and mouse_y > 150 and mouse_y < 200
        undo_move()
      end
      mouse_over_piece()     
    end
  end
  def check_valid_moves(moves)
    if @turn == 'white'
      temp_locations = @white_locations[@current_piece].dup
      moves.each do |move|
        @white_locations[@current_piece] = move
        captured = false
        if @black_locations.include?(move)
          temp_capture = move
          temp_pieces = @black_pieces[@black_locations.index(move)]
          temp_index = @black_locations.index(move)
          @black_pieces.delete_at(temp_index)
          @black_locations.delete_at(temp_index)           
          captured = true
        end
        @turn = 'black'
        king_check()
        if @check == true
          @to_delete << move             
          @check = false
        end
        @white_locations[@current_piece] = temp_locations
        if captured == true
          @black_locations << move
          @black_pieces << temp_pieces
        end
        @turn = 'white' 
      end
      if @to_delete
        @to_delete.each do |move|
          moves.delete(move)
        end
        @to_delete = []
      end
    elsif @turn == 'black'
      temp_locations = @black_locations[@current_piece]
      moves.each do |move|
        @black_locations[@current_piece] = move
        captured = false
        if @white_locations.include?(move)
          temp_capture = move
          temp_pieces = @white_pieces[@white_locations.index(move)]
          temp_index = @white_locations.index(move)
          @white_pieces.delete_at(temp_index)
          @white_locations.delete_at(temp_index)           
          captured = true
        end
        @turn = 'white'
        king_check()
        if @check == true
          @to_delete << move             
          @check = false
        end
        @black_locations[@current_piece] = temp_locations
        if captured == true
          @white_locations << move
          @white_pieces << temp_pieces
        end
        @turn = 'black' 
      end
      if @to_delete
        @to_delete.each do |move|
          moves.delete(move)
        end
      end
      @to_delete = []
    end
  end
  
  def evaluate_move
    white_val = count_material('white')
    black_val = count_material('black')
    evaluation = white_val - black_val
    perspective = (@turn == 'white')? 1 : -1
    return evaluation*perspective
  end
  
  def count_material(color)
    material = 0 
    if color == 'black'
      @black_pieces.each do |piece|
        case piece
        when "pawn"
          material += PAWN_VALUE
        when 'rook'
          material += ROOK_VALUE
        when 'knight'
          material += KNIGHT_VALUE
        when 'bishop'
          material+= BISHOP_VALUE
        when 'queen'
          material+= QUEEN_VALUE
        end
      end
    elsif color=='white'
      @white_pieces.each do |piece|
        case piece
        when "pawn"
          material += PAWN_VALUE
        when 'rook'
          material += ROOK_VALUE
        when 'knight'
          material += KNIGHT_VALUE
        when 'bishop'
          material+= BISHOP_VALUE
        when 'queen'
          material+= QUEEN_VALUE
        end
      end
    end
    return material
  end

  def random_move
    max_move = []
    
    max_score = 0
    if @turn =='black'     
      @all_pos_move = check_all_option(@black_pieces,@black_locations)
      @all_piece_move = check_all_piece(@black_pieces,@black_locations)
      for i in (0..(@all_pos_move.length-1))
        temp_locations = @black_locations.dup
        temp_pieces = @black_pieces.dup
        @current_piece = @black_locations.index(@all_piece_move[i])
        #check_valid_move(@all_pos_move[i])
      end
      # if can_castle?( "king")
      #   @all_pos_move << [1,7]
      #   @all_piece_move << 'king'
      # elsif  can_castle?( "queen")
      #   @all_pos_move << [5,7]
      #   @all_piece_move << 'king'
      # end
      @to_delete.each do |del_move|
        @all_piece_move.delete_at(@all_pos_move.index(del_move))
        @all_pos_move.delete(del_move)
      end
      for i in (0..(@all_pos_move.length-1))
        @current_piece = @black_locations.index(@all_piece_move[i])
        #puts @current_piece
        move = @all_pos_move[i].dup
        temp_black_locations = @black_locations.dup
        temp_white_locations = @white_locations.dup
        temp_black_pieces = @black_pieces.dup
        temp_white_pieces = @white_pieces.dup
        @black_locations[@current_piece] = move
        capture()
        score = evaluate_move()
        if score > max_score
          max_score = score
          max_move = move
          @max_piece = @current_piece.dup
        end
        @black_locations = temp_black_locations
        @black_pieces = temp_black_pieces
        @white_pieces = temp_white_pieces
        @white_locations = temp_white_locations
      end
      if @max_piece
        @black_locations[@max_piece] = max_move
        @max_piece = nil
      else
        rand_ind = rand(0..(@all_pos_move.length-1))
        @black_locations[@black_locations.index(@all_piece_move[rand_ind])] = @all_pos_move[rand_ind]
      end
      capture()
      king_check()
      @turn = 'white'
    end
  end

  def generate_moves
    @all_pos_move = check_all_option(@white_pieces,@white_locations) if @turn == 'white'
    @all_piece_move = check_all_piece(@white_pieces,@white_locations) if @turn == 'white'
    @all_pos_move = check_all_option(@black_pieces,@white_locations) if @turn =='black'
    @all_piece_move = check_all_piece(@black_pieces,@white_locations) if @turn =='black'
    @evaluation_board = evaluate_move()
    move = search_best_move(@evaluation_board,3,false,-Float::INFINITY,Float::INFINITY)
  end

  def search_best_move(node,depth, isMaximizer, alpha,beta)
    if depth == 0
      return node
    end
    if isMaximizer 
      best_val = -Float::INFINITY
      @evaluation_board.each do |move|
        move = evaluate_move
        value = search_best_move(move,depth-1,false,alpha,beta)
        best_val = max(best_val,value)
        alpha = max(alpha,best_val)
        if beta <= alpha
          break
        end
      end
      return best_val
    else
      best_val = Float::INFINITY
      @evaluation_board.each do |move|
        value = search_best_move(move,depth-1,true,alpha,beta)
        best_val = min(best_val,value)
        beta = min(best_val,beta)
        if beta <= alpha
          break
        end
      end
      return best_val
    end
  end
  def check_valid_move(move)
    if @turn == 'white'
      temp_locations = @white_locations[@current_piece].dup
      @white_locations[@current_piece] = move
      captured = false
      if @black_locations.include?(move)
        temp_capture = move
        emp_pieces = @black_pieces[@black_locations.index(move)]
        temp_index = @black_locations.index(move)
        @black_pieces.delete_at(temp_index)
        @black_locations.delete_at(temp_index)           
        captured = true
      end
      @turn ='black'
      king_check()
      if @check == true
        @to_delete << move             
        @check = false
      end
        @white_locations[@current_piece]=temp_locations
      if captured == true
        @black_locations << move
        @black_pieces << temp_pieces
      end
        @turn = 'white'      
    elsif @turn =='black'
        temp_locations = @black_locations[@current_piece]
        @black_locations[@current_piece] = move
        captured = false
        if @white_locations.include?(move)
          temp_capture = move
          temp_pieces = @white_pieces[@white_locations.index(move)]
          temp_index = @white_locations.index(move)
          @white_pieces.delete_at(temp_index)
          @white_locations.delete_at(temp_index)           
          captured = true
        end
        @turn ='white'
        king_check()
        if @check == true
          @to_delete << move             
          @check = false
        end
        @black_locations[@current_piece]=temp_locations
        if captured == true
          @white_locations << move
          @white_pieces << temp_pieces
        end
        @turn = 'black'  
    end
  end
end

Main.new.show