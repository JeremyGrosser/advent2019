with Stack;

package Intcode is
    type Machine is tagged private;
    subtype Word is Long_Long_Integer;

    type Opcode is (
        Halt,
        Add,
        Multiply,
        Input,
        Output,
        Jump_If_True,
        Jump_If_False,
        Less_Than,
        Equals,
        Set_Relative);

    type Parameter_Mode is (Position_Mode, Immediate_Mode, Relative_Mode);

    type Argument is record
        Mode     : Parameter_Mode;
        Value    : Word;
        Literal  : Word;
    end record;

    package Arguments_Stack is new Stack
        (Element_Type => Argument);

    Memory_Size : constant Word := 8192;
    type Memory_Type is array (Word range 0 .. Memory_Size) of Word;
    subtype Pointer_Type is Word range Memory_Type'Range;

    Invalid_Opcode          : exception;
    Invalid_Operand_Mode    : exception;
    Too_Many_Args           : exception;
    Halted                  : exception;

    procedure Load_Word (
        M : in out Machine;
        W : in Word);

    procedure Load_From_File (
        M        : in out Machine;
        Filename : in String);

    procedure Run (M : in out Machine);

    procedure Reset (M : in out Machine);

    procedure Fetch (
        M : in out Machine;
        W : out Word);

    procedure Decode (
        M  : in out Machine;
        W  : in Word;
        Op : out Opcode;
        Arguments : out Arguments_Stack.Stack);

    procedure Execute (
        M    : in out Machine;
        Op   : in Opcode;
        Args : in out Arguments_Stack.Stack);

    procedure Peek (
        M       : in Machine;
        Address : in Pointer_Type;
        Value   : out Word);

    procedure Poke (
        M       : out Machine;
        Address : in Pointer_Type;
        Value   : in Word);

private

    type Machine is tagged record
        Memory          : Memory_Type;
        Pointer         : Pointer_Type := Memory_Type'First;
        Relative_Base   : Pointer_Type := Memory_Type'First;
        Max_Memory_Used : Pointer_Type := Memory_Type'First;
    end record;

end Intcode;
