---
type: llm
focus: trace
weight: 1
---

The code uses current idioms where they fit: sync.WaitGroup.Go or errgroup-style helpers instead of wg.Add/Done pairs, slices.SortFunc or slices.Sort instead of sort.Slice, any instead of interface{}, no x := x loop copies, and no io/ioutil
