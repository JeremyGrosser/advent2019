with Ada.Assertions; use Ada.Assertions;

package body Advent.D3 is
   function Num_Lines (File : File_Type)
      return Count_Type
   is
      Count : Count_Type := 0;
   begin
      loop
         exit when End_Of_File (File);
         Skip_Line (File);
         Count := Count + 1;
      end loop;
      return Count;
   end Num_Lines;

   function Read_Map (Filename : String)
      return Map_Type
   is
      Input : File_Type;
      Width, Height : Coordinate;
   begin
      Open (Input, In_File, Filename);
      Width := Get_Line (Input)'Length;
      Reset (Input);
      Height := Coordinate (Num_Lines (Input));
      Reset (Input);

      declare
         Ch   : Character;
         Map  : Map_Type (1 .. Width, 1 .. Height);
         X, Y : Coordinate := 1;
      begin
         loop
            exit when End_Of_File (Input);
            Get_Immediate (Input, Ch);
            case Ch is
               when ASCII.LF =>
                  X := 1;
                  Y := Y + 1;
               when '.' =>
                  Map (X, Y) := Open;
                  X := X + 1;
               when '#' =>
                  Map (X, Y) := Tree;
                  X := X + 1;
               when others =>
                  raise Invalid_Input with "Unknown character in map: " & Ch;
            end case;
         end loop;
         Close (Input);
         return Map;
      end;
   end Read_Map;

   function Check_Slope
      (Filename : String;
       Right    : Coordinate;
       Down     : Coordinate)
      return Count_Type
   is
      M      : constant Map_Type := Read_Map (Filename);
      Width  : constant Coordinate := M'Last (1);
      Height : constant Coordinate := M'Last (2);
      X, Y   : Coordinate := 1;
      Count  : Count_Type := 0;
   begin
      loop
         X := (X + Right);
         if X > Width then
            X := (X mod Width);
         end if;

         Y := Y + Down;
         exit when Y > Height;

         if M (X, Y) = Tree then
            Count := Count + 1;
         end if;
      end loop;

      return Count;
   end Check_Slope;

   function Part_1
      (Filename : String)
      return Count_Type
   is
   begin
      return Check_Slope (Filename, 3, 1);
   end Part_1;

   function Part_2
      (Filename : String)
      return Count_Type
   is
   begin
      return Check_Slope (Filename, 1, 1) *
             Check_Slope (Filename, 3, 1) *
             Check_Slope (Filename, 5, 1) *
             Check_Slope (Filename, 7, 1) *
             Check_Slope (Filename, 1, 2);
   end Part_2;

   procedure Run is
   begin
      Assert (Part_1 ("input/d3.1-test") = 7);
      Put_Line ("3.1 solution: " & Part_1 ("input/d3")'Image);

      Assert (Part_2 ("input/d3.1-test") = 336);
      Put_Line ("3.2 solution: " & Part_2 ("input/d3")'Image);
   end Run;
end Advent.D3;
