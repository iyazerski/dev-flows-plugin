package orders

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"
)

const sample = `[
  {"id": "b2", "customer": "bob", "items": [{"sku": "pen", "qty": 3, "price_cents": 150}]},
  {"id": "a1", "customer": "ann", "items": [{"sku": "ink", "qty": 1, "price_cents": 900}, {"sku": "pad", "qty": 2, "price_cents": 250}]}
]`

func load(t *testing.T) *OrderService {
	path := filepath.Join(t.TempDir(), "orders.json")
	if err := os.WriteFile(path, []byte(sample), 0o644); err != nil {
		t.Fatal(err)
	}
	s := NewOrderService(NewOrderRepositoryImpl())
	if err := s.LoadFromFile(path); err != nil {
		t.Fatal(err)
	}
	return s
}

func TestTotal(t *testing.T) {
	s := load(t)
	if got := s.Total("a1"); got != 1400 {
		t.Fatalf("Total(a1) = %d, want 1400", got)
	}
}

func TestReport(t *testing.T) {
	s := load(t)
	want := "a1 ann new 1400\nb2 bob new 450\n"
	if got := s.Report(false); got != want {
		t.Fatalf("Report(false) = %q, want %q", got, want)
	}
}

func TestCancel(t *testing.T) {
	s := load(t)
	if err := s.Cancel("a1"); err != nil {
		t.Fatal(err)
	}
	o, _ := s.GetRepo().Get("a1")
	if o.Status != "cancelled" {
		t.Fatalf("status = %q, want cancelled", o.Status)
	}
}

func TestProcessAll(t *testing.T) {
	s := load(t)
	errs := s.ProcessAll(func(_ context.Context, o *Order) error {
		if o.Customer == "bob" {
			return errors.New("blocked customer")
		}
		return nil
	})
	if len(errs) != 1 {
		t.Fatalf("got %d errors, want 1", len(errs))
	}
}
