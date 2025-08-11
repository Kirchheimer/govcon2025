<?php

// Security and Code Quality Issues

// Hardcoded credentials
$db_user = 'admin';
$db_pass = 'password123';

// SQL Injection vulnerability
$id = $_GET['id'];
$query = "SELECT * FROM users WHERE id = " . $id;

// XSS vulnerability
echo "Welcome, " . $_GET['name'];

// Unused variable
$unused = 'this is not used';

function anotherFunction()
{
    // Magic number
    if (time() % 2 == 0) {
        return 27;
    }
}

?>
