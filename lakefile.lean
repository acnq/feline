import Lake
open Lake DSL

package feline {
  -- add package configuration options here
}

lean_lib Feline {
  -- add library configuration options here
}

@[defaultTarget]
lean_exe feline {
  root := `Main
}
