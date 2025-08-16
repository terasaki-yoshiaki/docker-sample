package com.calculator.model;

import jakarta.validation.constraints.NotNull;

public class CalculationRequest {
    @NotNull
    private Double firstNumber;
    
    @NotNull
    private Double secondNumber;
    
    @NotNull
    private String operation;

    public Double getFirstNumber() {
        return firstNumber;
    }

    public void setFirstNumber(Double firstNumber) {
        this.firstNumber = firstNumber;
    }

    public Double getSecondNumber() {
        return secondNumber;
    }

    public void setSecondNumber(Double secondNumber) {
        this.secondNumber = secondNumber;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }
}