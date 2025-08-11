<?php

// PSR-12 Violations

class bad_class_name { // Class name should be StudlyCaps
    public function A_Function_With_Bad_Name($arg1,$arg2) { // Method name should be camelCase, space missing after comma
        $some_variable=1; // Space missing around equals sign

        if($some_variable==1){ // Space missing after if and around ==
            echo 'Hello';
        } else{ // else should be on the same line as the closing brace of if
            echo "world";
        }
    }
}

?>
