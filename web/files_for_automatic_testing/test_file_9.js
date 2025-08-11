// Final JS test file with errors

(function() {
    "use strict";

    var my_var = "hello"; // Not camelCase
    
    if (my_var == "hello") { // loose equality
        // no-alert rule violation
        alert("Hello!");
    }

    // no-console rule violation
    console.log("This is a test");

})();
