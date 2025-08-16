let display = document.getElementById('display');
let currentInput = '0';
let history = [];

function updateDisplay() {
    display.textContent = currentInput;
}

function clearDisplay() {
    currentInput = '0';
    updateDisplay();
}

function appendToDisplay(value) {
    if (currentInput === '0' && value !== '.') {
        currentInput = value;
    } else {
        currentInput += value;
    }
    updateDisplay();
}

function deleteLast() {
    if (currentInput.length > 1) {
        currentInput = currentInput.slice(0, -1);
    } else {
        currentInput = '0';
    }
    updateDisplay();
}

async function calculate() {
    try {
        const expression = currentInput;
        
        const operators = expression.match(/[+\-*/]/g);
        const numbers = expression.split(/[+\-*/]/);
        
        if (operators && operators.length > 0 && numbers.length > 1) {
            let operator = operators[0];
            let operand1 = parseFloat(numbers[0]);
            let operand2 = parseFloat(numbers[1]);
            
            if (numbers.length > 2) {
                for (let i = 1; i < operators.length; i++) {
                    const tempResult = await performCalculation(operand1, operand2, operator);
                    operand1 = tempResult;
                    operator = operators[i];
                    operand2 = parseFloat(numbers[i + 1]);
                }
            }
            
            const response = await fetch('/api/calculator/calculate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    operand1: operand1,
                    operand2: operand2,
                    operator: operator
                })
            });
            
            const data = await response.json();
            
            if (data.success) {
                const result = data.result;
                addToHistory(`${expression} = ${result}`);
                currentInput = result.toString();
                updateDisplay();
            } else {
                alert('エラー: ' + data.error);
            }
        } else {
            const result = eval(expression);
            addToHistory(`${expression} = ${result}`);
            currentInput = result.toString();
            updateDisplay();
        }
    } catch (error) {
        alert('計算エラー: ' + error.message);
    }
}

async function performCalculation(operand1, operand2, operator) {
    const response = await fetch('/api/calculator/calculate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            operand1: operand1,
            operand2: operand2,
            operator: operator
        })
    });
    
    const data = await response.json();
    if (data.success) {
        return data.result;
    } else {
        throw new Error(data.error);
    }
}

function addToHistory(calculation) {
    history.unshift(calculation);
    if (history.length > 10) {
        history.pop();
    }
    updateHistory();
}

function updateHistory() {
    const historyList = document.getElementById('history-list');
    historyList.innerHTML = '';
    
    if (history.length === 0) {
        historyList.innerHTML = '<div style="color: #999; text-align: center;">履歴なし</div>';
    } else {
        history.forEach(item => {
            const div = document.createElement('div');
            div.className = 'history-item';
            div.textContent = item;
            historyList.appendChild(div);
        });
    }
}

document.addEventListener('keydown', function(event) {
    if (event.key >= '0' && event.key <= '9') {
        appendToDisplay(event.key);
    } else if (event.key === '.') {
        appendToDisplay('.');
    } else if (event.key === '+' || event.key === '-' || event.key === '*' || event.key === '/') {
        appendToDisplay(event.key);
    } else if (event.key === 'Enter' || event.key === '=') {
        calculate();
    } else if (event.key === 'Escape' || event.key === 'c' || event.key === 'C') {
        clearDisplay();
    } else if (event.key === 'Backspace') {
        deleteLast();
    }
});

updateHistory();