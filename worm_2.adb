with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.numerics.discrete_random;
with randgen; use randgen; 
with apple_list;
use apple_list;
package body worm_2 is

subtype Rand_Range is Positive;
package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);

    -- ------------------------------------------------------------
    procedure display_title is
    begin
            put_line("██╗    ██╗ ██████╗ ██████╗ ███╗   ███╗    ███╗   ███╗ █████╗ ███╗   ██╗");
            put_line("██║    ██║██╔═══██╗██╔══██╗████╗ ████║    ████╗ ████║██╔══██╗████╗  ██║");
            put_line("██║ █╗ ██║██║   ██║██████╔╝██╔████╔██║    ██╔████╔██║███████║██╔██╗ ██║");  
            put_line("██║███╗██║██║   ██║██╔══██╗██║╚██╔╝██║    ██║╚██╔╝██║██╔══██║██║╚██╗██║");
            put_line("╚███╔███╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║    ██║ ╚═╝ ██║██║  ██║██║ ╚████║");
            put_line(" ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝");

        end display_title;
    ----------------------------------------------------------------
    ----------------------------------------------------------------
    procedure game_over is
    begin
  
 
      put_line(" ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ ");
      put_line("██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗");
      put_line("██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝");
      put_line("██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗");
      put_line("╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║");
      put_line(" ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝");
                                                                          
    end game_over;
   -----------------------------------------------------------------
    PROCEDURE MoveCursor (Column : integer; Row : integer) IS
        BEGIN
           Ada.Text_IO.Flush;
           Ada.Text_IO.Put (Item => ASCII.ESC);
           Ada.Text_IO.Put ("[");
           Ada.Integer_Text_IO.Put (Item => Row, Width => 1);
           Ada.Text_IO.Put (Item => ';');
           Ada.Integer_Text_IO.Put (Item => Column, Width => 1);
           Ada.Text_IO.Put (Item => 'f');
        END MoveCursor;

        ---------------------------------------------------------------
    
procedure get_level(level_one : out maparray; level : in mapstring) is
       level_file : file_type;
        begin

           open(level_file, in_file, level);
           for y in 1..HEIGHT loop
              for x in 1..LENGTH loop
                 get(level_file, level_one(x,y));
              end loop;
              skip_line(level_file);
           end loop;
           close(level_file);
        end get_level;


    ----------------------------------------------------------------

       procedure get_hscore(hplayer :  out hs_string; num :  out integer) is

        -- Opens a file to get the top score and the top player’s initials, or creates a new file;

        hs_file : file_type; -- File variable

        begin
                open(file => hs_file, mode => in_file, name => "High_Score");
                get(file => hs_file, item => hplayer); --there may not be anything to get...so it just waits here
                ada.integer_text_io.get(file => hs_file, item => num);
		put("High Score is: ");
                new_line;
		put(hplayer);
	        put (" ");
		put(num,0);
--	end loop;
        close(hs_file);
        end get_hscore;
--------------------------------------------------------------------------------------

        procedure write_hscore(hplayer : in hs_string; num : in integer) is

        -- Writes the Highscore and the top player's intials into a file.

        hs_file : file_type; -- File variable

        begin
                open(file => hs_file, mode => out_file, name => "High_Score");
                put(file => hs_file, item => hplayer);
                ada.integer_text_io.put(file => hs_file, item => num);
                close(hs_file);
        end write_hscore;


    ----------------------------------------------------------------

    procedure print_level(level : in maparray; pos_x,pos_y,app_x,app_y: out integer ) is

    begin
       for y in 1..HEIGHT loop
          for x in 1..LENGTH loop
                 if (level(x,y) = 'x')then
                   put(item=>ascii.esc); -- Changes color back to white
                   ada.text_io.put(item=> "[36m");


                    put("█");
                 elsif (level(x,y) = 'w') then
                    put(item=>ascii.esc);
		    ada.text_io.put(item=>"[33m");
                    put("█");
		     put(item=>ascii.esc); -- Changes color back to white
                    ada.text_io.put(item=> "[37m");

                 elsif (level(x,y) = '*') then
                     put(item=>ascii.esc); -- Changes color back to white
                     ada.text_io.put(item=> "[31m");

		     put("Ó");
                    put(item=>ascii.esc); -- Changes color back to white
                    ada.text_io.put(item=> "[37m");

                 else
                    put(level(x,y));
                 end if;
              end loop;
              new_line;
       end loop;

           --get the location of w on the map, send it back to main program
           --to mark where the starting positon of the snake will be on the map
           for y in 1..HEIGHT loop
              for x in 1..LENGTH loop
                 if(level(x,y)='w') then
                    --location := level_one(x,y);
                    MoveCursor(x,y);
                    pos_x := x;
                    pos_y := y;
                 end if;
              end loop;
       end loop;

        for y in 1..HEIGHT loop
              for x in 1..LENGTH loop
                 if(level(x,y)='*') then
                    app_x := x;
                    app_y := y;
                 end if;
              end loop;
       end loop;


    

    end print_level;
    ----------------------------------------------------------------
        procedure display_menu is
  
	-- Displays the menu at the start of the game

           HSI : hs_string;
           hscore : integer;

        begin
     
        clearscreen;
        display_title;  --call title banner
        get_hscore(HSI,hscore);
        if(hscore>0) then
           MoveCursor(24,8);
           put(HSI,0);
           put(": ");
	   ada.integer_text_io.put(Item => hscore, width => 0);

       end if;

        MoveCursor(24,8);
        put_line("1. New Game");
        MoveCursor(24,9);
        put_line("2. Quit");
        MoveCursor(32,10);

        while (not ((user_input(1) = '1') or (user_input(1) = '2'))) loop
           if((user_input(1) /= '1') or (user_input(1) /= '2')) then
              dead := false;
              dead := true;
           end if;
        end loop;

       if (user_input(1) = '1') then
          dead := false;
          cont := true;
       else
          dead := true;
          cont := false;
       end if;

   end display_menu;
   ------------------------------------------------------------------ 
       PROCEDURE ClearScreen IS

    	-- Clears the screen, then sets the cursor to the upper left of the
	-- prompt.

        BEGIN
           Ada.Text_IO.Put (Item => ASCII.ESC);
           Ada.Text_IO.Put (Item => "[2J");
           Ada.Text_IO.Flush;
           MoveCursor(1, 1);
       end clearscreen;

    -- -------------------------------------------------------------
    procedure gen_apple(x,y : in out integer; worm_size : in out worm_length;
		        level : in maparray) is

    -- Randomly generates new apple coordinates
 
    begin

       x := generate_random_number(38);
       y := generate_random_number(18);
       --check if worm is here

        while ((not(worm_size(x,y).d = none)) OR ((level(x,y) = 'x')))  loop -- Checks if new coordinates for apple are on a worm tile
	       x := generate_random_number(38);
      	       y := generate_random_number(18);
       end loop;

       MoveCursor(x,y);
       ada.text_io.put(item=>ascii.esc);
       ada.text_io.put(item=> "[31m");
       put("Ó");
       ada.text_io.put(item=>ascii.esc);
       ada.text_io.put(item=> "[37m");

    end gen_apple;
    ----------------------------------------------------------------
    
    procedure worm_move(map : in maparray; 
                        location   : in out worm_location;
                        b_location : in out worm_location; 
                        worm_Size  : in out worm_length;
                        apple  : in out boolean;
                        status : in out boolean;
			list   : in out apple_list.aptr;
                        apple_x, apple_y : in out integer) is

    begin

      --resets life_count if user decides to play again after game over
        
        ada.text_io.put(item => ascii.esc);
        ada.text_io.put(item=> "[32m"); 
        MoveCursor(location.x,location.y);
        if (control_input(1) = 'w') then      -- User moves up
 	      location.d := up;            -- Sets worm path for tail to follow
	      worm_size(location.x, location.y).d := location.d; -- Adds worm to the path
              location.y := location.y - 1; -- Changes to new coordinates
              location.x := location.x;
              MoveCursor(location.x,location.y);
              put("█"); -- Prints the worm in the new loctaion

	      -- The code below flows a similar aglorithm as above

        elsif (control_input(1) = 'd') then  -- Player moves right
	      location.d := right;
	      worm_size(location.x, location.y).d := location.d;
              location.y := location.y;
              location.x := location.x + 1;
              MoveCursor(location.x,location.y);
              put("█");
          
        elsif (control_input(1) = 's') then -- Player moves down
              location.d := down;
              worm_size(location.x, location.y).d := location.d;
              location.y := location.y + 1;
              location.x := location.x;
              MoveCursor(location.x,location.y);
              put("█");
                      
        elsif (control_input(1) = 'a') then -- Player moves left
  	      location.d := left;
              worm_size(location.x, location.y).d := location.d;
              location.y := location.y;
              location.x := location.x - 1;
              MoveCursor(location.x,location.y);
       	      put("█");

        end if;


        if (apple = false) then -- An apple was eaten, and the worm grows

            -- Clears the tail, and moves coordinates to the next 'w'
            -- If apple is true, this is not ran, so the worm grows one.

            if (worm_size(b_location.x, b_location.y).d = up) then -- If the worm moved up
           	Worm_size(b_location.x, b_location.y).d := none; -- Clears tail in array
                MoveCursor(b_location.x, b_location.y); -- Moves cursor to that tail
                put(" "); -- Clears worms's tail location.
                b_location.y := b_location.y - 1; -- Changes coordinate to new location
               	location.d := worm_size(b_location.x, b_location.y).d; -- Tail is next tail spot
            	--MoveCursor(location.x,location.y);

            elsif (worm_size(b_location.x, b_location.y).d = right) then -- If the worm moved right
                worm_size(b_location.x, b_location.y).d := none;
                MoveCursor(b_location.x, b_location.y);
                put(" "); -- Clears worms's tail location.
                b_location.x := b_location.x + 1;
                location.d := worm_size(b_location.x, b_location.y).d;
                --MoveCursor(location.x,location.y);

            elsif (worm_size(b_location.x, b_location.y).d = down) then -- if the worm moved down
                worm_size(b_location.x, b_location.y).d := none;
                MoveCursor(b_location.x, b_location.y);
                put(" "); -- Clears worms's tail location.
                b_location.y := b_location.y + 1;
                location.d := worm_size(b_location.x, b_location.y).d;
                --MoveCursor(location.x,location.y);

            elsif (worm_size(b_location.x, b_location.y).d = left) then -- if the worm moved left
                worm_size(b_location.x, b_location.y).d := none;
                MoveCursor(b_location.x, b_location.y);
                put(" "); -- Clears worms's tail location.
                b_location.x := b_location.x - 1;
                location.d := worm_size(b_location.x, b_location.y).d;
                --MoveCursor(location.x,location.y);

            end if;
	else
		apple := false;
		speed := speed*0.95;
        end if;


        if (map(location.x, location.y) = 'x') then -- Worm runs into a wall
          -- put("WALL!");
           status := True;  --worm hit a wall and is dead, reset game, decrement life count
           life_count := life_count - 1;
         --  put("life count is now: ");
	 --  put(life_count);
        elsif ((location.x = apple_x) and (location.y = apple_y)) then -- Worm eats an apple
		apple := true;
		apple_list.add_apple(list); -- Adds an apple to a list for score
                MoveCursor(34,21);
		ada.integer_text_io.put(item=>apple_list.get_score(list), width => 0);
 		gen_apple(apple_x,apple_y,worm_size,map);
		movecursor(location.x, location.y);
        elsif (not (worm_size(location.x, location.y).d = none)) then -- Worm runs into itself
         --  put("Worm!");
           status := true; --Worm hit itself and is dead, reset game, decrement life count
           life_count := life_count - 1;
        end if;

       ada.text_io.put(item=>ascii.esc); -- Changes color back to white
       ada.text_io.put(item=> "[37m");

end worm_move;

    -- -------------------------------------------------------------

end worm_2;





