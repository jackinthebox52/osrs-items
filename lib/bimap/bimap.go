package bimap

import "sync"

// BiMap is a bidirectional map that allows lookups in both directions
type BiMap struct {
	forward map[int]string
	reverse map[string]int
	mu      sync.RWMutex
}

// New creates a new BiMap
func New() *BiMap {
	return &BiMap{
		forward: make(map[int]string),
		reverse: make(map[string]int),
	}
}

// Set adds or updates a key-value pair
func (b *BiMap) Set(id int, name string) {
	b.mu.Lock()
	defer b.mu.Unlock()

	// Remove old mappings if they exist
	if oldName, exists := b.forward[id]; exists {
		delete(b.reverse, oldName)
	}
	if oldID, exists := b.reverse[name]; exists {
		delete(b.forward, oldID)
	}

	b.forward[id] = name
	b.reverse[name] = id
}

// GetByID retrieves name by ID
func (b *BiMap) GetByID(id int) (string, bool) {
	b.mu.RLock()
	defer b.mu.RUnlock()
	name, exists := b.forward[id]
	return name, exists
}

// GetByName retrieves ID by name
func (b *BiMap) GetByName(name string) (int, bool) {
	b.mu.RLock()
	defer b.mu.RUnlock()
	id, exists := b.reverse[name]
	return id, exists
}
