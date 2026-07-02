package main

import "core:fmt"
import "core:os"
import cli "src/cli"

main :: proc() {
	// Read the command line arguments.
	args := os.args[1:]

	fmt.println("args: ", args)

}
