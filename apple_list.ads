package apple_list is

-- -----------------------------------------------------
-- Date: 4/8/2015
-- Purpose: List to contain apples eaten, and keep score
-- ------------------------------------------------------

    Type aptr is private;

    procedure add_apple(list: in out aptr);
    procedure initialize(list : in out aptr);
    function get_score(list: in aptr) return integer;
    function clear_apple(list: aptr) return aptr;

    PRIVATE

   Type Apple_rec  Is Record
      next: aptr;
   End Record;

   Type aptr is access Apple_rec;

end apple_list;

