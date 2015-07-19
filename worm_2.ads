with ada.numerics.discrete_random;
with apple_list;

package worm_2 is

-- ---------------------------------------------------------------------
-- Date: 3/13/2015 - ???
-- Purpose: Test map code, uses task to stop render.
-- ---------------------------------------------------------------------

    LENGTH : constant integer := 40;    
    HEIGHT : constant integer := 20;
    subtype hs_string is string(1..3);
    subtype map_unit is string(1..1); -- What will be in each coordinate of the level.
    type maparray is array(1..LENGTH, 1..HEIGHT) of character; -- Array to contain a map (Or game level)
    type direction is (none, up, right, down, left);
   -- type lives is range 1..3;

    type worm_location is record
        x : integer := 0; -- X-coordinate (First in array)
        y : integer := 0; -- Y-coordinate (last in array)
        d : direction := none;
    end record;

    type worm_length is array(1..LENGTH, 1..HEIGHT) of worm_location;
	
    subtype mapstring is string(1..8);    
    user_input : map_unit; -- Variable for quiting render
    cont       : boolean := true; -- Continue boolean
    dead       : boolean := false; -- Dead is global
    speed       : duration := 0.3;
    life_count : integer := 3; --keeps track of lives
    control_input : map_unit; --variable for getting controls

---------------------------------------------------------------------------------


procedure display_title;
--Pre: None
--Post: Title of the game is displayed on the screen

PROCEDURE MoveCursor (Column : integer; Row : integer);
--Pre: Column and Row are defined
--Post: Cursor is moved to column and row input to the procedure

procedure get_level(level_one : out maparray; level : in mapstring);
--Pre: a file exists in the current directory that contains a map. Also a 2D 
--     array must be declared that contains the dimensions of the map

--Post: the map file is stored in the 2D array

procedure print_level(level : in maparray; pos_x,pos_y,app_x,app_y: out integer );
--Pre: level, pos_x, pos_y are defined
--Post: the map is printed to the screen

procedure display_menu;
--displays worm man banner and prompts user to 
--play a new game or quit game

procedure game_over;
--display game over banner
--prompts user to play again or quit


PROCEDURE ClearScreen;
--Pre: None

--Post: Clears the screen and sets the cursor to the top left corner
--      of the window

procedure get_hscore(hplayer :  out hs_string; num :  out integer);
procedure write_hscore(hplayer : in hs_string; num : in integer);

procedure worm_move(map : in maparray; 
                    location   : in out worm_location;
                    b_location : in out worm_location; 
                    worm_Size  : in out worm_length;
                    apple  : in out boolean;
                    status : in out boolean;
		    list   : in out apple_list.aptr;
                    apple_x,apple_y : in out integer);
--Pre: 

--Post:


--procedure gen_apple(apple : out character);
--Pre:

--Post:


end worm_2;
