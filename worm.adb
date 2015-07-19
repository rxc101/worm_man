with ada.text_io;
with ada.integer_text_io;
use ada.text_io;

procedure worm is

-- ---------------------------------------------------------------------
-- Author: Derek Moncilovich
-- Date: 3/13/2015
-- Purpose: Test map code, uses task to stop render.
-- ---------------------------------------------------------------------
        LENGTH : constant integer := 20;	
        HEIGHT : constant integer := 10;

	subtype map_unit is string(1..1); -- What will be in each coordinate of the level.
	type maparray is array(1..LENGTH, 1..HEIGHT) of character; -- Array to contain a map (Or game level)
	type direction is (up, right, down, left);

	type worm_location is record
	    x : integer := 0; -- X-coordinate (First in array)
	    y : integer := 0; -- Y-coordinate (last in array)
	    d : direction := right;
	end record;
	
	user_input : map_unit; -- Variable for quiting render

	-- -------------------------------------------------------------

	task quit;
	task body quit is

	-- Task to get user input to stop the rendering of the map.

	begin
		loop
			ada.text_io.get_immediate(user_input(1));
			if (user_input(1) = 'q') then
				exit;	
			end if;
		end loop;
	end quit;

	-- -------------------------------------------------------------
	

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
	--gets the map file
	

	procedure get_level(level_one : out maparray) is
	   level_one_file : file_type;
        begin
         
           open(level_one_file, in_file, "level_one");
           for y in 1..HEIGHT loop
              for x in 1..LENGTH loop
                 get(level_one_file, level_one(x,y));
              end loop;
              skip_line(level_one_file);
           end loop;
           close(level_one_file);
        end get_level;

	----------------------------------------------------------------

	procedure print_level(level_one : in maparray) is
	begin
	   for y in 1..HEIGHT loop
	      for x in 1..LENGTH loop
                 put(level_one(x,y));

              end loop;
              new_line;

           end loop;
	end print_level;

	----------------------------------------------------------------
	procedure rendermap(map : in maparray) is
	
	-- Prints the level from the array. 

	begin -- rendermap
		put(map(1, 10));
		for i in 1..10 loop
			for j in 1..10 loop
				put(map(i, j));
			end loop;
			new_line;
		end loop;
	end rendermap;

	-- -------------------------------------------------------------
	

	-- Clears the screen, then sets the cursor to the upper left of the
	-- prompt. 
 
       PROCEDURE ClearScreen IS
        BEGIN
           Ada.Text_IO.Put (Item => ASCII.ESC);
           Ada.Text_IO.Put (Item => "[2J");
           Ada.Text_IO.Flush;

	end clearscreen;

	-- -------------------------------------------------------------
	
	procedure worm_move(map : in maparray; location : in out worm_location ) is

	begin
		if (user_input(1) = 'w') then
                           
                        MoveCursor(location.x,location.y);
	--		set_line(location.y); -- Sets cursor to worm
         --               set_col(location.x);
                        put(" "); -- Clears original worms's location.
                        location.y := location.y - 1;
                       location.x := location.x;
                  --      set_line(location.y);
                   --     set_col(location.x);
                        MoveCursor(location.x,location.y);
                        put("w");
		elsif (user_input(1) = 'd') then
                       MoveCursor(location.x,location.y);

			--set_line(location.y); -- Sets 
			--set_col(location.x);
			put(" "); -- Clears original x's location.
			location.y := location.y;
			location.x := location.x + 1;
		--	set_line(location.y);
                ---	set_col(location.x);
                        MoveCursor(location.x,location.y);
			put("w");
		elsif (user_input(1) = 's') then
                       MoveCursor(location.y,location.x);

	--		set_line(location.y); -- Sets
         --               set_col(location.x);
                        put(" "); -- Clears original x's location.
                        location.y := location.y + 1;
                        location.x := location.x;
                  --      set_line(location.y);
                   --     set_col(location.x);
                    MoveCursor(location.x,location.y);

                        put("w");
		elsif (user_input(1) = 'a') then
         		MoveCursor(location.y,location.x);

			--set_line(location.y); -- Sets
                        --set_col(location.x);
                        put(" "); -- Clears original x's location.
                        location.y := location.y;
                        location.x := location.x - 1;
                  --      set_line(location.y);
                   --     set_col(location.x);
                        put("w");
		end if;
	end worm_move;

	-- -------------------------------------------------------------

	lvl01    : maparray;
	worm_l : worm_location;

begin -- worm
--	for i in 1..10 loop -- Hardcode the map for test
--		for j in 1..10 loop
--			if ((i = 1) or (i = 10) or (j = 1) or (j = 10)) then
--				lvl01(i, j) := "X";
--			else
--				lvl01(i, j) := " ";
--			end if;
--		end loop;
--	end loop;
	clearscreen;

--	rendermap(LVL01);


	worm_l.x := 2;
	worm_l.y := 2;
	lvl01(2, 2) := 'w';

	get_level(lvl01);
   	print_level(lvl01);


	while not (user_input(1) = 'q') loop -- Calls clearscreen and rendermap until "q" is typed.
		

          	delay 0.5;
		worm_move(lvl01, worm_l);
	end loop;
end worm;

