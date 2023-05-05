import Feline

-- 3 different main
-- main : IO Unit  => can't read cmdline args and always return exitcode of 0
-- main : IO UInt32 => int main(void) 
-- main : List String → IO UInt32 => int main(int argc, char ** argv)

def main (args : List String) : IO UInt32 :=
  match args with
  | [] => process 0 ["-"]
  | _ => process 0 args
  
