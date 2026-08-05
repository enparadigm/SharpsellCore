function capitalizeWords(str) {
  return str
      .split(' ')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
}
function formatNumber(numberString, includeSymbol = false) {
    let number = parseFloat(numberString);
    if (isNaN(number)) {
        return "InvalidNumber";
    }

    let [integerPart, decimalPart] = number.toString().split('.');
    decimalPart = decimalPart ? '.' + decimalPart : '';

    let lastThree = integerPart.slice(-3);
    let otherNumbers = integerPart.slice(0, -3);

    if (otherNumbers) {
        lastThree = ',' + lastThree;
    }

    let formattedNumber = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree + decimalPart;

    return includeSymbol ? '₹' + formattedNumber : formattedNumber;
}

function currency(numberString) {
    return formatNumber(numberString, true);
}

function max(numbers) {
  if (!Array.isArray(numbers) || numbers.length === 0) {
    return null; // Return null for empty or non-array input
  }
  return Math.max(...numbers);
}
function date(inputDateString) {
    const currentDate = inputDateString ? new Date(inputDateString.replace(/(\d{2})\/(\d{2})\/(\d{4})/, "$3-$2-$1")) : new Date();
    const year = currentDate.getFullYear();
    const month = (currentDate.getMonth() + 1).toString().padStart(2, "0");
    const day = currentDate.getDate().toString().padStart(2, "0");
    return `${day}-${month}-${year}`;
}
function sum(numbers) {
  if (!Array.isArray(numbers)) {
        console.error("Input is not an array");
        return 0; // Return 0 or handle the error in some other way
    }
    return numbers.reduce((total, num) => total + num, 0);
}
function evaluateExpression(form,user,output) {
    const result = `{customExpression}`;
    return result;
}
evaluateExpression(JSON.parse(`{formDataString}`),JSON.parse(`{userDataString}`),JSON.parse(`{outputString}`));