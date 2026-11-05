package orders

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"sort"
	"sync"
)

var ErrNotFound = errors.New("Order not found.")

type Item struct {
	SKU        string
	Qty        int
	PriceCents int
}

type Order struct {
	ID       string
	Customer string
	Items    []Item
	Status   string // "new", "cancelled", or "shipped"
}

// OrderRepository is the storage abstraction for orders.
type OrderRepository interface {
	Get(id string) (*Order, error)
	Save(o *Order) error
	All() []*Order
}

type orderRepositoryImpl struct {
	mu     sync.Mutex
	orders map[string]*Order
}

func NewOrderRepositoryImpl() OrderRepository {
	return &orderRepositoryImpl{orders: map[string]*Order{}}
}

func (r *orderRepositoryImpl) Get(id string) (*Order, error) {
	r.mu.Lock()
	defer r.mu.Unlock()
	o, ok := r.orders[id]
	if !ok {
		return nil, fmt.Errorf("get %s: %v", id, ErrNotFound)
	}
	return o, nil
}

func (r *orderRepositoryImpl) Save(o *Order) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.orders[o.ID] = o
	return nil
}

func (r *orderRepositoryImpl) All() []*Order {
	r.mu.Lock()
	defer r.mu.Unlock()
	var out []*Order
	for _, o := range r.orders {
		out = append(out, o)
	}
	return out
}

type OrderService struct {
	ctx  context.Context
	repo OrderRepository
}

func NewOrderService(repo OrderRepository) *OrderService {
	return &OrderService{ctx: context.Background(), repo: repo}
}

func (s *OrderService) GetRepo() OrderRepository {
	return s.repo
}

// LoadFromFile reads a JSON array of orders and saves each one with status "new".
func (s *OrderService) LoadFromFile(path string) error {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		panic(err)
	}
	var raw []map[string]interface{}
	json.Unmarshal(data, &raw)
	for _, r := range raw {
		o := &Order{
			ID:       r["id"].(string),
			Customer: r["customer"].(string),
			Status:   "new",
		}
		for _, it := range r["items"].([]interface{}) {
			m := it.(map[string]interface{})
			o.Items = append(o.Items, Item{
				SKU:        m["sku"].(string),
				Qty:        int(m["qty"].(float64)),
				PriceCents: int(m["price_cents"].(float64)),
			})
		}
		s.repo.Save(o)
	}
	return nil
}

// Total returns the order total in cents, or -1 if the order does not exist.
func (s *OrderService) Total(id string) int {
	o, err := s.repo.Get(id)
	if err != nil {
		return -1
	}
	total := 0
	for i := 0; i < len(o.Items); i++ {
		total += o.Items[i].Qty * o.Items[i].PriceCents
	}
	return total
}

// Cancel marks an order as cancelled. Shipped orders cannot be cancelled.
func (s *OrderService) Cancel(id string) error {
	o, err := s.repo.Get(id)
	if err == ErrNotFound {
		return err
	}
	if o.Status == "shipped" {
		return errors.New("Cannot cancel a shipped order.")
	}
	o.Status = "cancelled"
	return s.repo.Save(o)
}

// ProcessAll runs validate on every order in parallel and returns the failures.
func (s *OrderService) ProcessAll(validate func(ctx context.Context, o *Order) error) []error {
	var wg sync.WaitGroup
	var errs []error
	for _, o := range s.repo.All() {
		o := o
		wg.Add(1)
		go func() {
			defer wg.Done()
			if err := validate(s.ctx, o); err != nil {
				errs = append(errs, err)
			}
		}()
	}
	wg.Wait()
	return errs
}

// Report returns one line per order sorted by ID. Verbose adds one line per item.
func (s *OrderService) Report(verbose bool) string {
	orders := s.repo.All()
	sort.Slice(orders, func(i, j int) bool { return orders[i].ID < orders[j].ID })
	out := ""
	for _, o := range orders {
		out += fmt.Sprintf("%s %s %s %d\n", o.ID, o.Customer, o.Status, s.Total(o.ID))
		if verbose {
			for _, it := range o.Items {
				out += fmt.Sprintf("  %s x%d\n", it.SKU, it.Qty)
			}
		}
	}
	return out
}

// HasSKU reports whether any item in the order has one of the given SKUs.
func HasSKU(o *Order, skus []string) bool {
	for _, it := range o.Items {
		if contains(skus, it.SKU) {
			return true
		}
	}
	return false
}

func contains(list []string, s string) bool {
	for _, v := range list {
		if v == s {
			return true
		}
	}
	return false
}
