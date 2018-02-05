defmodule CalcTest do
  use ExUnit.Case
#  doctest Calc

  test "(1 + 2 + 3) = 6" do
    assert Calc.eval("1 + 2 + 3") == 6
  end

  test "(1 * ( 2 * 3 * ( 5 / 5)))" do
    assert Calc.eval("(1 * ( 2 * 3 * ( 5 / 5)))") == 6
  end

  test "(1 * ( 2 * 3 * ( 4 / 5)))" do
    assert Calc.eval("(1 * ( 2 * 3 * ( 4 / 5)))") == 0
  end

  test "24 / 6 + (5 - 4)" do
    assert Calc.eval("24 / 6 + (5 - 4)") == 5
  end

  test "1 + 3 * 3 + 1" do
    assert Calc.eval("1 + 3 * 3 - 1") == 9
  end

  test "0 + 0 - 1  + ( 45 * 1000)" do
    assert Calc.eval("0 + 0 - 1  + ( 45 * 1000)") == 44999
  end
end
