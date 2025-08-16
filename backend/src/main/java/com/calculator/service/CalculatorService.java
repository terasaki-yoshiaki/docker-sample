package com.calculator.service;

import com.calculator.model.CalculationRequest;
import com.calculator.model.CalculationResponse;
import org.springframework.stereotype.Service;

@Service
public class CalculatorService {

    public CalculationResponse calculate(CalculationRequest request) {
        Double firstNumber = request.getFirstNumber();
        Double secondNumber = request.getSecondNumber();
        String operation = request.getOperation();
        
        try {
            Double result;
            String expression;
            
            switch (operation.toLowerCase()) {
                case "add":
                case "+":
                    result = firstNumber + secondNumber;
                    expression = String.format("%.2f + %.2f = %.2f", firstNumber, secondNumber, result);
                    break;
                case "subtract":
                case "-":
                    result = firstNumber - secondNumber;
                    expression = String.format("%.2f - %.2f = %.2f", firstNumber, secondNumber, result);
                    break;
                case "multiply":
                case "*":
                    result = firstNumber * secondNumber;
                    expression = String.format("%.2f × %.2f = %.2f", firstNumber, secondNumber, result);
                    break;
                case "divide":
                case "/":
                    if (secondNumber == 0) {
                        return new CalculationResponse("Cannot divide by zero");
                    }
                    result = firstNumber / secondNumber;
                    expression = String.format("%.2f ÷ %.2f = %.2f", firstNumber, secondNumber, result);
                    break;
                case "power":
                case "^":
                    result = Math.pow(firstNumber, secondNumber);
                    expression = String.format("%.2f ^ %.2f = %.2f", firstNumber, secondNumber, result);
                    break;
                case "sqrt":
                    if (firstNumber < 0) {
                        return new CalculationResponse("Cannot calculate square root of negative number");
                    }
                    result = Math.sqrt(firstNumber);
                    expression = String.format("√%.2f = %.2f", firstNumber, result);
                    break;
                default:
                    return new CalculationResponse("Invalid operation: " + operation);
            }
            
            return new CalculationResponse(result, expression);
        } catch (Exception e) {
            return new CalculationResponse("Calculation error: " + e.getMessage());
        }
    }
}