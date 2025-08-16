import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  SafeAreaView,
  ScrollView,
  TextInput,
  Alert,
  Platform
} from 'react-native';
import { StatusBar } from 'expo-status-bar';
import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL 
  ? `${process.env.REACT_APP_API_URL}/api/calculator`
  : Platform.OS === 'web' 
    ? 'http://localhost:8080/api/calculator'
    : 'http://10.0.2.2:8080/api/calculator';

interface CalculationResponse {
  result: number;
  expression: string;
  success: boolean;
  error?: string;
}

export default function App() {
  const [display, setDisplay] = useState('0');
  const [previousNumber, setPreviousNumber] = useState<string>('');
  const [operation, setOperation] = useState<string>('');
  const [waitingForNewNumber, setWaitingForNewNumber] = useState(false);
  const [history, setHistory] = useState<string[]>([]);

  const inputNumber = (num: string) => {
    if (waitingForNewNumber) {
      setDisplay(num);
      setWaitingForNewNumber(false);
    } else {
      setDisplay(display === '0' ? num : display + num);
    }
  };

  const inputDecimal = () => {
    if (waitingForNewNumber) {
      setDisplay('0.');
      setWaitingForNewNumber(false);
    } else if (display.indexOf('.') === -1) {
      setDisplay(display + '.');
    }
  };

  const clear = () => {
    setDisplay('0');
    setPreviousNumber('');
    setOperation('');
    setWaitingForNewNumber(false);
  };

  const performOperation = (nextOperation: string) => {
    const inputValue = parseFloat(display);

    if (previousNumber === '') {
      setPreviousNumber(display);
    } else if (operation) {
      const currentValue = parseFloat(previousNumber);

      calculateResult(currentValue, inputValue, operation);
    }

    setWaitingForNewNumber(true);
    setOperation(nextOperation);
  };

  const calculateResult = async (firstNumber: number, secondNumber: number, op: string) => {
    try {
      const response = await axios.post<CalculationResponse>(`${API_URL}/calculate`, {
        firstNumber,
        secondNumber,
        operation: op
      });

      if (response.data.success) {
        setDisplay(String(response.data.result));
        setPreviousNumber(String(response.data.result));
        setHistory([...history, response.data.expression]);
      } else {
        Alert.alert('Error', response.data.error || 'Calculation failed');
      }
    } catch (error) {
      console.error('Calculation error:', error);
      
      let result = 0;
      switch (op) {
        case '+':
          result = firstNumber + secondNumber;
          break;
        case '-':
          result = firstNumber - secondNumber;
          break;
        case '*':
          result = firstNumber * secondNumber;
          break;
        case '/':
          result = secondNumber !== 0 ? firstNumber / secondNumber : 0;
          break;
      }
      setDisplay(String(result));
      setPreviousNumber(String(result));
    }
  };

  const calculate = () => {
    const inputValue = parseFloat(display);
    const currentValue = parseFloat(previousNumber);

    if (previousNumber !== '' && operation !== '') {
      calculateResult(currentValue, inputValue, operation);
      setOperation('');
      setPreviousNumber('');
      setWaitingForNewNumber(true);
    }
  };

  const Button = ({ onPress, title, style = {}, textStyle = {} }: any) => (
    <TouchableOpacity onPress={onPress} style={[styles.button, style]}>
      <Text style={[styles.buttonText, textStyle]}>{title}</Text>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="auto" />
      
      <View style={styles.displayContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <Text style={styles.display}>{display}</Text>
        </ScrollView>
      </View>

      <View style={styles.historyContainer}>
        <ScrollView>
          {history.slice(-3).map((item, index) => (
            <Text key={index} style={styles.historyText}>{item}</Text>
          ))}
        </ScrollView>
      </View>

      <View style={styles.buttonContainer}>
        <View style={styles.row}>
          <Button onPress={clear} title="C" style={styles.functionButton} />
          <Button onPress={() => performOperation('/')} title="÷" style={styles.operatorButton} />
          <Button onPress={() => performOperation('*')} title="×" style={styles.operatorButton} />
          <Button onPress={() => performOperation('-')} title="-" style={styles.operatorButton} />
        </View>

        <View style={styles.row}>
          <Button onPress={() => inputNumber('7')} title="7" />
          <Button onPress={() => inputNumber('8')} title="8" />
          <Button onPress={() => inputNumber('9')} title="9" />
          <Button onPress={() => performOperation('+')} title="+" style={styles.operatorButton} />
        </View>

        <View style={styles.row}>
          <Button onPress={() => inputNumber('4')} title="4" />
          <Button onPress={() => inputNumber('5')} title="5" />
          <Button onPress={() => inputNumber('6')} title="6" />
          <Button onPress={() => performOperation('^')} title="^" style={styles.operatorButton} />
        </View>

        <View style={styles.row}>
          <Button onPress={() => inputNumber('1')} title="1" />
          <Button onPress={() => inputNumber('2')} title="2" />
          <Button onPress={() => inputNumber('3')} title="3" />
          <Button onPress={() => performOperation('sqrt')} title="√" style={styles.operatorButton} />
        </View>

        <View style={styles.row}>
          <Button onPress={() => inputNumber('0')} title="0" style={styles.zeroButton} />
          <Button onPress={inputDecimal} title="." />
          <Button onPress={calculate} title="=" style={styles.equalsButton} />
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  displayContainer: {
    flex: 1,
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    padding: 20,
    backgroundColor: '#2a2a2a',
    marginBottom: 10,
  },
  display: {
    fontSize: 48,
    color: '#ffffff',
    fontWeight: '300',
  },
  historyContainer: {
    height: 80,
    paddingHorizontal: 20,
    backgroundColor: '#2a2a2a',
    marginBottom: 10,
  },
  historyText: {
    color: '#888',
    fontSize: 14,
    paddingVertical: 2,
  },
  buttonContainer: {
    paddingBottom: 20,
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 10,
    paddingHorizontal: 10,
  },
  button: {
    width: 75,
    height: 75,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#3a3a3a',
    borderRadius: 40,
    margin: 5,
  },
  buttonText: {
    fontSize: 28,
    color: '#ffffff',
    fontWeight: '400',
  },
  functionButton: {
    backgroundColor: '#5a5a5a',
  },
  operatorButton: {
    backgroundColor: '#ff9500',
  },
  equalsButton: {
    backgroundColor: '#4cd964',
  },
  zeroButton: {
    width: 160,
  },
});