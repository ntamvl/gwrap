var page = new WebPage();
var system = require('system');
var address = system.args[1];
var timeout = 0;
page.open(address, function(status) {
    just_wait();
});

function just_wait() {
    setTimeout(function() {
        console.log(page.content);
        phantom.exit();
    }, timeout);
}
