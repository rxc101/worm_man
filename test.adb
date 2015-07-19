with ada.text_io;
with ada.integer_text_io;
with Interfaces.C;
use ada.text_io;

procedure worm is


-- ---------------------------------------------------------------------
-- Date: 3/13/2015 - ???
-- Purpose: Test map code, uses task to stop render.
-- ---------------------------------------------------------------------
        LENGTH : constant integer := 20;    
        HEIGHT : constant integer := 10;

    subtype map_unit is string(1..1); -- What will be in each coordinate of the level.
    type maparray is array(1..LENGTH, 1..HEIGHT) of character; -- Array to contain a map (Or game level)
    type direction is (none, up, right, down, left);

    type worm_location is record
        x : integer := 0; -- X-coordinate (First in array)
        y : integer := 0; -- Y-coordinate (last in array)
        d : direction := none;
    end record;

    type worm_length is array(1..LENGTH, 1..HEIGHT) of worm_location;
    
    user_input : map_unit; -- Variable for quiting render
    cont       : boolean := true; -- Continue boolean
    dead       : boolean := false; -- Dead is global

    -- -------------------------------------------------------------

      task quit;
      task body quit is

     --  Task to get user input to stop the rendering of the map.

     begin
        loop
            if (dead = false) then
                ada.text_io.get_immediate(user_input(1));
            end if;
            if (cont = false) then
                exit;    
            end if;
        end loop;
    end quit;

    -- ------------------------------------------------------------
    procedure display_title is
    begin
    --This can be ignored, it generates an ASCII graphic title screen “Worm Man”
    --I found an ASCII art generator at http://www.patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=Worm%20Man
            --put_line("     ██╗    ██╗ ██████╗ ██████╗ ███╗   ███╗    ███╗   ███╗ █████╗ ███╗   ██╗");
            --put_line("     ██║    ██║██╔═══██╗██╔══██╗████╗ ████║    ████╗ ████║██╔══██╗████╗  ██║");
            --put_line("     ██║ █╗ ██║██║   ██║██████╔╝██╔████╔██║    ██╔████╔██║███████║██╔██╗ ██║");  
            --put_line("     ██║███╗██║██║   ██║██╔══██╗██║╚██╔╝██║    ██║╚██╔╝██║██╔══██║██║╚██╗██║");
            --put_line("     ╚███╔███╔╝╚██████╔╝██║  ██║██║ ╚═╝ ██║    ██║ ╚═╝ ██║██║  ██║██║ ╚████║");
            --put_line("      ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝");
          put_line("title");

        end display_title;
    ----------------------------------------------------------------

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

procedure print_level(level_one : in maparray; pos_x,pos_y: out integer ) is
    begin
       for y in 1..HEIGHT loop
          for x in 1..LENGTH loop
                 put(level_one(x,y));
              end loop;
              new_line;
       end loop;

           --get the location of w on the map, send it back to main program
           --to mark where the starting positon of the snake will be on the map
           for y in 1..HEIGHT loop
          for x in 1..LENGTH loop
                 if(level_one(x,y)='w') then
             --location := level_one(x,y);
            MoveCursor(x,y);
            pos_x := x;
            pos_y := y;
         end if;
              end loop;
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
MoveCursor(1, 1);
    end clearscreen;

    -- -------------------------------------------------------------
    
    procedure worm_move(map : in maparray; 
                location : in out worm_location;
                            b_location: in out worm_location; 
                worm_Size: in out worm_length;
                apple: in out boolean;
                status : in out boolean ) is

    begin

        
   --things to consder: 
   --   *Press any key to begin the worm game...
   
   --   I think it would be neat to fire off a timer that says 3....2......1. Go! then
   --   the snake starts moving to the right by default. (currently you have to press w,a,s,or d to get it to start)


        MoveCursor(location.x,location.y);
        if (user_input(1) = 'w') then
                        location.y := location.y - 1;
                        location.x := location.x;
                        MoveCursor(location.x,location.y);
                        put("w");
                        location.d := up;

            if (b_location.d = none) then -- sets first worm direction
                                worm_size(b_location.x, b_location.y).d := up;
                        end if;

        elsif (user_input(1) = 'd') then
            location.y := location.y;
            location.x := location.x + 1;
                        MoveCursor(location.x,location.y);
            put("w");
            location.d := right;

            if (b_location.d = none) then -- sets first worm direction
                                worm_size(b_location.x, b_location.y).d := right;
                        end if;
                     
        elsif (user_input(1) = 's') then
                       location.y := location.y + 1;
                       location.x := location.x;
                       MoveCursor(location.x,location.y);
                       put("w");
               location.d := down;

            if (b_location.d = none) then -- sets first worm direction
                                worm_size(b_location.x, b_location.y).d := down;
                        end if;
                      
        elsif (user_input(1) = 'a') then
                        location.y := location.y;
                        location.x := location.x - 1;
                        MoveCursor(location.x,location.y);
                        put("w");
            location.d := left;

            if (b_location.d = none) then -- sets first worm direction
                worm_size(b_location.x, b_location.y).d := left;
            end if;

        end if;

        if (apple = false) then

            -- Clears the tail, and moves coordinates to the next 'w'
            -- If apple is true, this is not ran, so the worm grows one.

            if (worm_size(b_location.x, b_location.y).d = up) then -- If the worm moved up
                worm_size(b_location.x, b_location.y).d := none; -- Clears tail in array
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
        end if;

        if (map(location.x, location.y) = 'x') then
                            put("WALL!");
                               status := True;  --worm hit a wall and is dead, reset game, decrement life count
        elsif (not (worm_size(location.x, location.y).d = none)) then
                put("Worm!");
                status := true; --Worm hit itself and is dead, reset game, decrement life count
             end if;
        worm_size(location.x, location.y).d := location.d;
           end worm_move;

    -- -------------------------------------------------------------

    lvl01  : maparray;
    worm_l : worm_location;
    worm_b : worm_location;
    worm_f : worm_length;
        pos_x,pos_y : integer;

begin -- worm

        while cont = true loop   
        clearscreen;
        --change the background of the level to blue
            --Ada.Text_IO.Put (Item => ASCII.ESC);
            --Ada.Text_IO.Put (Item => "[44m");
    
            pos_x := 0;
            pos_y := 0;
            dead := false;
    
        for y in 1..HEIGHT loop
        -- All coordinates are set to none, or no worm. 
        -- This is to check if the worm has eaten itself,
        -- and what path the worm's tail travels that will
        -- be removed
            for x in 1..LENGTH loop
                worm_f(x, y).d := none;
            end loop;
        end loop;
    
        get_level(lvl01);
           print_level(lvl01,pos_x,pos_y);

        worm_l.x := pos_x;
            worm_l.y := pos_y;
        worm_b.x := pos_x;
            worm_b.y := pos_y;    

        while (dead = false) loop
                
                  delay 0.5;
            worm_move(lvl01, worm_l, worm_b, worm_f, dead, dead); -- First dead is a place holder until apple is written (ascii char 229 looks like an apple)
    
            if dead = true then
                new_line(10);
                put_line("you're dead.");
                put("play again? (y/n):");
                while (not ((user_input(1) = 'n') or (user_input(1) = 'y'))) loop
                    dead := true; -- Pointless filler
                end loop;
                if (user_input(1) = 'n') then
                    cont := false;
                 end if;
                end if;
        end loop;
    end loop;
end worm;





