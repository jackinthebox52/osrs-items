package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"

	"github.com/jackinthebox52/osrs-items/lib/data"
)

func main() {
	// Set up flags
	verbose := flag.Bool("v", false, "verbose output")
	flag.BoolVar(verbose, "verbose", false, "verbose output")

	flag.Parse()
	args := flag.Args()

	if len(args) < 1 {
		fmt.Println("Usage: osrs-items [-v|--verbose] <item-id or item-name>")
		os.Exit(1)
	}

	query := args[0]

	// Try to parse as ID first
	if id, err := strconv.Atoi(query); err == nil {
		if name, exists := data.Items.GetByID(id); exists {
			if *verbose {
				fmt.Printf("Item %d: %s\n", id, name)
			} else {
				fmt.Println(name)
			}
		} else {
			if *verbose {
				fmt.Printf("No item found with ID: %d\n", id)
			} else {
				fmt.Println("Not found")
			}
		}
		return
	}

	// If not an ID, try as name
	if id, exists := data.Items.GetByName(query); exists {
		if *verbose {
			fmt.Printf("Item '%s' has ID: %d\n", query, id)
		} else {
			fmt.Println(id)
		}
	} else {
		if *verbose {
			fmt.Printf("No item found with name: %s\n", query)
		} else {
			fmt.Println("Not found")
		}
	}
}
