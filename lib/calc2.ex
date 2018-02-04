defmodule Calc2 do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.

  ## Examples

  iex> Calc.hello
  :world

  """
  def hello do
    :world
  end

  def eval(expression) do
    String.replace(expression, "(", "( ")
    |> String.replace(")", " )")
    |> String.split
      #    |> Enum.map(fn (x) -> if (x != "+" && x != "-" && x != "/" && x != "*" && x != "(" && x != ")") do
      #                            String.to_integer(x)
      #                          else x
      #                          end
      #    end)
    |> evaluate
  end

  def evaluate(list) do
    #    operandStack = []
    #    operatorStack = []
    {operandStack, operatorStack} = List.foldl(
      list,
      {operandStack, operatorStack} = {[], []},
      fn (x, acc) ->
        {operandStack, operatorStack} = acc
        cond do
          x != "+" && x != "-" && x != "/" && x != "*" && x != "(" && x != ")" ->
            {List.insert_at(operandStack, 0, x), operatorStack}
          x == "(" ->
            {operandStack, List.insert_at(operatorStack, 0, x)}

          x == "+" || x == "-" || x == "/" || x == "*" ->
            {operandStack, operatorStack} = evaluate(operatorStack, operandStack, x)

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
                operandStack = List.insert_at(operandStack, 0, performOperation(first, second, operator))
              end
            )

            {operandStack, Enum.take(operatorStack, - length(operatorStack) + index + 1)}

          true -> ""

        end
      end
    )

    List.first(
      List.foldl(
        operatorStack,
        operandStack,
        fn (operator, operandStack) ->
          first = List.first(operandStack)
          operandStack = List.delete_at(operandStack, 0)
          second = List.first(operandStack)
          operandStack = List.delete_at(operandStack, 0)
          operandStack = List.insert_at(operandStack, 0, performOperation(first, second, operator))
        end
      )
    )
  end

  def evaluate(operatorStack, operandStack, operation)  do

    IO.puts "operator stack "
    IO.puts operatorStack
    IO.puts "operand stack "
    IO.puts operandStack

    lastOperator = List.first(operatorStack)

    if (length(operatorStack) >= 1 && precedence?(operation, lastOperator)) do
      IO.puts "Precedence is greater"
      operatorStack = List.delete_at(operatorStack, 0)
      first = List.first(operandStack)
      operandStack = List.delete_at(operandStack, 0)
      second = List.first(operandStack)
      operandStack = List.delete_at(operandStack, 0)
      operandStack = List.insert_at(operandStack, 0, performOperation(first, second, lastOperator))
      {operandStack, operatorStack} = evaluate(operatorStack, operandStack, operation)
    else
      operatorStack = List.insert_at(operatorStack, 0, operation)
      {operandStack, operatorStack}
    end


  end

  def performOperation(op1, op2, operator) do
    #    IO.puts op1
    #    IO.puts operator
    #    IO.puts op2
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

  def main do
    # eval("1+2+3")
  end

end
