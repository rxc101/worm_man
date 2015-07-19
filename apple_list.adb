WITH Unchecked_Deallocation;
package body apple_list is

-- ------------------------------------
-- Singly linked list body
-- 4/8/2015
-- ------------------------------------

procedure free is new unchecked_deallocation(Object => apple_rec, name => aptr);

-- -------------------------------------------------------
-- Adds an apple to the list when eaten

   procedure add_apple(list : in out aptr) is
   
   current : aptr := list;
   new_rec : aptr; 

   begin --add_apple
      new_rec := new apple_rec;
      new_rec.next := null;
      if list = null then -- List is empty
         list := new_rec;
      else -- Adds to end of list
	 while (not(current.next = null)) loop -- Loops to end of list
	    current := current.next;
	 end loop;
	 current.next := new_rec;
      end if;
   end add_apple;

-- -------------------------------------------------------
-- Initializes the list

   procedure initialize(list : in out aptr) is
   
   begin
	list := null;
   end initialize;

-- -------------------------------------------------------
-- Tallies up score and returns it

   function get_score(list : in aptr) return integer is

   n : integer := 0;
   current : aptr := list;

   begin --get_score
      while (not(current = null)) loop
         current := current.next;
	 n := n + 1;
      end loop;
      n := n*10;
      return n;
   end get_score;

-- -------------------------------------------------------
-- Clears the list for a new game.

   function clear_apple(list : aptr) return aptr is

   current  : aptr := list;
   previous : aptr := null;

   begin --clear_apple
      while (not(current = null)) loop
	previous := current;
	current := current.next;
	free(previous);
      end loop;
      return null;
   end clear_apple;

-- ---------------------------------------------------------

end apple_list;
