defmodule Calc do
  @moduledoc """
  The calculator supports evaluation of expressions consisting of
  arithmetic operations "+" , "-" , "/"  , "*" and parantheses

  Only Integer operations are supported.
  Expressions consisting of floating numbers might produce undesirable outputs
  """

  @doc """

  ## Examples

  iex> Calc.eval("1 + 2 + 3")
  6

  iex> Calc.eval("1 + 100 * 100 / 100")
  101

  iex> Calc.eval("24 / 6 + (5 - 4)")
  5

  """
  def eval(expression) do
    String.replace(expression, "(", "( ")
    |> String.replace(")", " )")
    |> String.split
    |> evaluate
  end

  def evaluate(list) do
    {operandStack, operatorStack} = List.foldl(
      list,
      {[], []},
      fn (x, acc) ->
        {operandStack, operatorStack} = acc
        cond do

          Regex.match?(~r/[0-9]+/, x) ->
            {List.insert_at(operandStack, 0, x), operatorStack}

          x == "(" ->
            {operandStack, List.insert_at(operatorStack, 0, x)}

          x == "+" || x == "-" || x == "/" || x == "*" ->
            evaluate(operatorStack, operandStack, x)

          x == ")" ->

            index = Enum.find_index(operatorStack, fn (x) -> x == "(" end)
            parenthesesOperatorStack = Enum.take(operatorStack, index)

            operandStack = List.foldl(
              parenthesesOperatorStack,
              operandStack,
              fn (operator, operandStack) ->
                first = List.first(operandStack)
                operandStack = List.delete_at(operandStack, 0)
                second = List.first(operandStack)
                operandStack = List.delete_at(operandStack, 0)
                List.insert_at(operandStack, 0, performOperation(first, second, operator))
              end
            )

            {operandStack, Enum.take(operatorStack, - length(operatorStack) + index + 1)}

          true -> raise "Invalid Input"

        end
      end
    )


    List.foldl(
      operatorStack,
      operandStack,
      fn (operator, operandStack) ->
        first = List.first(operandStack)
        operandStack = List.delete_at(operandStack, 0)
        second = List.first(operandStack)
        operandStack = List.delete_at(operandStack, 0)
        List.insert_at(operandStack, 0, performOperation(first, second, operator))
      end
    )
    |> List.first
    |> String.to_integer


  end

  def evaluate(operatorStack, operandStack, operation)  do
    lastOperator = List.first(operatorStack)

    if (length(operatorStack) >= 1 && precedence?(operation, lastOperator)) do
      operatorStack = List.delete_at(operatorStack, 0)
      first = List.first(operandStack)
      operandStack = List.delete_at(operandStack, 0)
      second = List.first(operandStack)
      operandStack = List.delete_at(operandStack, 0)
      operandStack = List.insert_at(operandStack, 0, performOperation(first, second, lastOperator))
      evaluate(operatorStack, operandStack, operation)
    else
      operatorStack = List.insert_at(operatorStack, 0, operation)
      {operandStack, operatorStack}
    end

  end

  def performOperation(op1, op2, operator) do
    cond do
      operator == "+" ->
        Integer.to_string(String.to_integer(op1) + String.to_integer(op2))
      operator == "-" ->
        Integer.to_string(String.to_integer(op2) - String.to_integer(op1))
      operator == "*" ->
        Integer.to_string(String.to_integer(op1) * String.to_integer(op2))
      operator == "/" ->
        Integer.to_string(div(String.to_integer(op2), String.to_integer(op1)))
      true -> ""
    end
  end


  def precedence?(operator1, operator2) do

    cond do
      operator2 == "(" || operator2 == ")" ->
        false
      ((operator1 == "*" || operator1 == "/") && (operator2 == "+" || operator2 == "-")) ->
        false
      true ->
        true
    end

  end

  def main() do
    expression = IO.gets "Please enter the expression\n"
    IO.puts eval(String.trim(expression))
    main()
  end

end
