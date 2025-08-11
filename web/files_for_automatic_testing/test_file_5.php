<?php

// Mixed Errors

// Deprecated function
$data = mysql_query("SELECT * FROM products");

function calculate($a, $b) {
    // Nested ternary operator - hard to read
    return $a > $b ? ($a > 100 ? 'big' : 'small') : ($b > 100 ? 'big' : 'small');
}

// Missing documentation
function process_data($data) {
    foreach ($data as $item) {
        echo $item;
    }
}

// Inconsistent indentation
    $x = 1;
  $y = 2;
 $z = 3;

?>
