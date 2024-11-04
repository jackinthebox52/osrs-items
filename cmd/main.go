package main

import (
	"fmt"
	"os"
	"strconv"

	"github.com/yourusername/osrs-items/data"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: osrs-items <item-id or item-name>")
		os.Exit(1)
	}

	query := os.Args[1]

	// Try to parse as ID first
	if id, err := strconv.Atoi(query); err == nil {
		if name, exists := data.Items.GetByID(id); exists {
			fmt.Printf("Item %d: %s\n", id, name)
		} else {
			fmt.Printf("No item found with ID: %d\n", id)
		}
		return
	}

	// If not an ID, try as name
	if id, exists := data.Items.GetByName(query); exists {
		fmt.Printf("Item '%s' has ID: %d\n", query, id)
	} else {
		fmt.Printf("No item found with name: %s\n", query)
	}
}
