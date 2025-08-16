package com.calculator.model;

public class CalculationResponse {
    private Double result;
    private String expression;
    private boolean success;
    private String error;

    public CalculationResponse(Double result, String expression) {
        this.result = result;
        this.expression = expression;
        this.success = true;
    }

    public CalculationResponse(String error) {
        this.success = false;
        this.error = error;
    }

    public Double getResult() {
        return result;
    }

    public void setResult(Double result) {
        this.result = result;
    }

    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }
}