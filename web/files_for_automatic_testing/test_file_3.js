// ESLint Violations

function someFunction (param1, param2) { // Extra space before parenthesis
  var x = 1; // Should use let or const
  if (x == "1") { // Should use ===
    console.log('hello'); // Should use single quotes
  }
  return
  'this is unreachable'; // Unreachable code after return
}
