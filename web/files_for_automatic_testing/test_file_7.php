<?php

// More PHP Errors

// Missing type declarations
function add($a, $b) {
    return $a + $b;
}

// Use of eval() is discouraged
$code = 'echo "Hello, world!";';
eval($code);

// Variable variables can be confusing
$var_name = 'foo';
$$var_name = 'bar'; // Creates a variable named $foo

?>
