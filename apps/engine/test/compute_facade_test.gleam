import compute_facade
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn sma_crosses_boundary_test() {
  compute_facade.sma([1.0, 2.0, 3.0, 4.0], 2)
  |> should.equal(Ok([1.5, 2.5, 3.5]))
}

pub fn sma_rejects_bad_window_test() {
  compute_facade.sma([1.0], 0)
  |> should.equal(Error("invalid input"))
}
