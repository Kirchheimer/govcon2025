<?php

// This file contains intentional coding standard violations for testing PHP_CodeSniffer
// It demonstrates various types of errors that automated linting tools can catch

// Missing docblock for class
class TestClass {
    // Missing visibility modifier
    var $oldStyleProperty;
    
    // Incorrect indentation (should be 4 spaces)
  private $badIndentation;
    
    // Missing docblock and incorrect naming convention
    public function badFunctionName($param1,$param2) {
        // Missing spaces around operators and after commas
        $result=$param1+$param2;
        return $result;
    }
    
    // Line too long (over 120 characters) - this is a very long line that exceeds the recommended line length limit for PHP coding standards
    public function anotherFunction() {
        echo "This line is intentionally very long to demonstrate line length violations in PHP coding standards checking tools";
    }
}

// Function without proper docblock
function testFunction($param) {
    echo "Hello, " . $param;
}

// Incorrect brace placement (should be on new line for functions)
function badBraceFunction() {
    $array = array(
        'key1' => 'value1',
        'key2' => 'value2',
        'key3' => 'value3'  // Missing trailing comma
    );
    return $array;
}

// Mixed tabs and spaces (this line uses tabs)
	function tabFunction() {
    echo "Mixed indentation";
}

// Unused variable
function unusedVariableFunction() {
    $unusedVar = "This variable is never used";
    echo "Function executed";
}

// Missing return type declaration
function noReturnType($input) {
    return strtoupper($input);
}

// Incorrect variable naming (should be camelCase or snake_case)
$BadVariableName = "incorrect naming";
$another_bad_var = "mixed conventions";

// Missing semicolon and incorrect spacing
$missingSpace="no spaces around equals"

// Deprecated function usage
$currentTime = mktime();

// SQL injection vulnerability (for security testing)
function vulnerableQuery($userId) {
    $query = "SELECT * FROM users WHERE id = " . $userId;
    // This would normally execute the query - intentionally vulnerable
    return $query;
}

// XSS vulnerability (for security testing)
function vulnerableOutput($userInput) {
    echo "<div>" . $userInput . "</div>";
}

// Hardcoded credentials (security issue)
$dbPassword = "hardcoded_password_123";
$apiKey = "sk-1234567890abcdef";

// Incorrect array syntax (old style)
$oldArray = array(
    'item1',
    'item2',
    'item3'
);

// Missing error handling
function noErrorHandling($filename) {
    $content = file_get_contents($filename);
    return $content;
}

// Incorrect comparison (should use === instead of ==)
function looseComparison($value) {
    if ($value == true) {
        return "loose comparison";
    }
    return "false";
}

// Magic numbers (should be constants)
function magicNumbers($input) {
    if (strlen($input) > 50) {
        return substr($input, 0, 25);
    }
    return $input;
}

// Missing input validation
function noValidation($email) {
    // Should validate email format
    return "Email: " . $email;
}

// Nested ternary operators (hard to read)
function nestedTernary($a, $b, $c) {
    return $a > $b ? ($b > $c ? $b : $c) : ($a > $c ? $a : $c);
}

// Function doing too many things (violates single responsibility)
function doEverything($data) {
    // Validate data
    if (empty($data)) {
        return false;
    }
    
    // Process data
    $processed = strtoupper(trim($data));
    
    // Log data
    error_log("Processing: " . $processed);
    
    // Save to database (simulated)
    $saved = true;
    
    // Send email notification (simulated)
    $emailSent = true;
    
    // Generate report (simulated)
    $report = "Report for: " . $processed;
    
    return array(
        'processed' => $processed,
        'saved' => $saved,
        'email_sent' => $emailSent,
        'report' => $report
    );
}

// Missing closing PHP tag is actually correct for pure PHP files
// But including it here for demonstration
?>
