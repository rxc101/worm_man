with ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with worm_2;
with ada.numerics.discrete_random;
use ada.text_io, worm_2;
with randgen;
use randgen;
with apple_list;

procedure test_worm2 is

    lvl01   : maparray;
    worm_l  : worm_location;
    worm_b  : worm_location;
    worm_f  : worm_length;
    pos_x,pos_y,app_x, app_y : integer;
    apple   : boolean;
    ap_list : apple_list.aptr;
    mapname : mapstring;
    Hscore  : integer;
    HSI     : hs_string;
    hs_file : file_type;
 -- -------------------------------------------------------------

      task quit;
      task body quit is

     --  Task to get user input to stop the rendering of the map.

     begin  --quit
        loop
            if (dead = false) then
                ada.text_io.get_immediate(user_input(1));

	        if((user_input(1) = 'w') or (user_input(1) = 'a') or (user_input(1) = 'd')
	           or (user_input(1) = 's')) then
                      control_input(1) := user_input(1);
                       
                end if;           
            end if;
            if (cont = false) then
               exit;    
            end if;
        end loop;
    end quit;

--------------------------------------------------------------------

begin -- worm
      Ada.Text_IO.Put (Item => ASCII.ESC); --removes cursor
      Ada.Text_IO.Put (Item => "[8;61;206t");


      Ada.Text_IO.Put (Item => ASCII.ESC); --removes cursor
      Ada.Text_IO.Put (Item => "[?25l");
      display_menu;
     
        while cont = true loop   
        clearscreen;
       
        
	if (life_count = 3) then
	   mapname :="Level_01";
	end if;


        dead := false;
	apple := false;
        pos_x := 0; --position of the worm on the map
        pos_y := 0;
        app_x := 0; --position of the apple on the map
        app_y := 0;    



        for y in 1..HEIGHT loop
        -- All coordinates are set to none, or no worm. 
        -- This is to check if the worm has eaten itself,
        -- and what path the worm's tail travels that will
        -- be removed
            for x in 1..LENGTH loop
                worm_f(x, y).d := none;
            end loop;
        end loop;

        get_level(lvl01,mapname);
        print_level(lvl01,pos_x,pos_y, app_x, app_y);
        MoveCursor(27,21);
	put("Score: ");
        put(item=>apple_list.get_score(ap_list),width=>0);         

        worm_l.x := pos_x;
        worm_l.y := pos_y;
        worm_b.x := pos_x;
        worm_b.y := pos_y;    

        ----------------------------------- display controls
        MoveCursor(1,26);
        put_line("Controls");
        put_line ("--------");
        put_line ("'w' = up");
        put_line ("'s' = down");
        put_line ("'a' = left");
        put_line ("'d' = right");
        ---------------------------------------------------

        while (dead = false) loop
                
            
	    delay speed;
            worm_move(lvl01, worm_l, worm_b, worm_f, apple, dead, ap_list, app_x, app_y); 
    
            if dead = true then
                control_input:="r";
                speed := 0.3;  -- Player is dead
                MoveCursor(1,21);
                put_line("you're dead.");
                put("play again? (y/n):");
                while (not ((user_input(1) = 'n') or (user_input(1) = 'y'))) loop -- Loop forcing the task to get input
                    if((user_input(1) /= 'n') or (user_input(1) /= 'y')) then -- User presses a different button than intended fix
                       dead := false;
                       dead := true;
                    end if;

                if (life_count = 2) then
                   mapname := "Level_02";
                elsif (life_count = 1)  then 
                  mapname := "Level_03";   
                else
		     -- (life_count = 0) 
  		       clearscreen;
		       game_over;
		       MoveCursor(24,8);	
		--	put_line ("game over!");
			put("play again? (y/n): ");
                        while (not ((user_input(1) = 'n') or (user_input(1) = 'y'))) loop
                           if((user_input(1) /= 'n') or (user_input(1) /= 'y')) then
                              dead := false;
                              dead := true;
                           end if;
                        end loop;
--			cont:=false;
--			exit;
                    end if;
                end loop;
		   
                if (user_input(1) = 'n') then -- Player quits
	            clearscreen;
                    cont := false;
                end if;
                if (life_count = 0) then
                   -- Clear apple list
                   life_count:=3;
		   get_hscore(HSI,hscore); 
		   if(hscore < apple_list.get_score(ap_list)) then
			new_line;
                       put_line("New High Score!");
		        put ("Please enter your initials: ");
                        get(item => HSI);

                 
		      write_hscore(HSI, apple_list.get_score(ap_list));
                   end if;
                  ap_list := apple_list.clear_apple(ap_list);
                end if;

         --      if (user_input(1) = 'y') then
	--	   life_count:=3;
        --        end if; 
            end if;
        end loop;
      end loop;

      Ada.Text_IO.Put (Item => ASCII.ESC); --removes cursor
      Ada.Text_IO.Put (Item => "[?25h");

end test_worm2;
