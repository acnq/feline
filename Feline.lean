def hello := "world"
def bufsize : USize := 20 * 1024 -- USize is like size_t, unsigned integer

-- Concetenating Streams

-- streams
-- redirect standard input to standard output
partial def dump (stream : IO.FS.Stream) : IO Unit := do
  let buf ← stream.read bufsize
  if buf.isEmpty then 
    pure ()
  else
    let stdout ← IO.getStdout -- only in else branch visible
    stdout.write buf
    dump stream -- tail recursion

-- partial : tolerate the 
-- calling of itself recursively on input 
-- that is not immediately smaller than an argument
-- when use partial
-- Lean does not require a proof that it terminates

-- IO.FS.Stream : POSIX Stream
namespace Hidden
structure Stream where
  flush : IO Unit
  read : USize → IO ByteArray
  write : ByteArray → IO Unit
  getline : IO String
  putStr : String → IO Unit
end Hidden 

-- open files and emit contents
def fileStream (filename : System.FilePath) : IO (Option IO.FS.Stream) := do 
  let fileExists ← filename.pathExists
  if not fileExists then 
    let stderr ← IO.getStderr
    stderr.putStrLn s!"File not found: {filename}"
    pure none
  else 
    let handle ← IO.FS.Handle.mk filename IO.FS.Mode.read
    pure (some (IO.FS.Stream.ofHandle handle)) -- fill field of struct Stream with corspd IO actions

def help : IO Unit := do
  IO.println s!"Hello, use as echo something | ./build/bin/feline test1.txt - test2.txt"


-- handling Input
def process (exitCode : UInt32) (args : List String) : IO UInt32 := do
  match args with
  | [] => pure exitCode
  | "-" :: args =>
    let stdin ← IO.getStdin
    dump stdin
    process exitCode args
  | "--help" :: args => 
    help
    process exitCode args
  | filename :: args =>
    let stream ← fileStream (filename)
    match stream with 
    | none =>
      process 1 args
    | some stream =>
      dump stream 
      process exitCode args

    

