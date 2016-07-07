function showSolution(data) {
    var len = data.length;
    var sol = $j("#solution");
    sol.empty();
    sol.append("<h2>Solution:</h2><p>");
    for (var i = 0; i < len; i++) {
        sol.append(data[i]);
	if (i + 1 == len) {
            sol.append(".");
        }
        else {
            sol.append(", ");
        }
    }
    sol.append("</p>");
}

function showError(error) {
    var sol = $j("#solution");
    sol.empty();
    sol.append("<h2>Error:</h2><p>" + error.error + "</p>");
    sol.append("</p>");
}
function submitBoard(e) {
    var obj = [
        [ $j("#r00").val(), $j("#r01").val(), $j("#r02").val(), $j("#r03").val() ],
        [ $j("#r10").val(), $j("#r11").val(), $j("#r12").val(), $j("#r13").val() ],
        [ $j("#r20").val(), $j("#r21").val(), $j("#r22").val(), $j("#r23").val() ],
        [ $j("#r30").val(), $j("#r31").val(), $j("#r32").val(), $j("#r33").val() ]
    ];
    $j.ajax({
        method: "POST",
        url: "/solve",
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function(data){ showSolution(data); },
        failure: function(errMsg) { showError(errMsg); }
    }); 
}

var $j = jQuery.noConflict();
$j( document ).ready(function() {
    $j("#submit_board").on("click", submitBoard);
});
