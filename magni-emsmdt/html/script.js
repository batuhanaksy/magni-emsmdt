$(document).ready(function(){
    $(".container").hide();
    $("#patient-createbutton").hide();
    $(".patient-search").hide();

    window.addEventListener("message", function(event){
        var data = event.data
        result = data.result
        if (data.type == "open") {
            $(".container").fadeIn(500);
        } else if (data.type == "search") {
            Search(result)
        }
    });

    $(document).on("click", "#patient-searchbutton", function () { 
        $(".patient-create").hide();
        $("#patient-searchbutton").hide();
        $("#patient-createbutton").show();
        $(".patient-search").show();
    })

    $(document).on("click", "#patient-createbutton", function () { 
        $("#patient-createbutton").hide();
        $(".patient-search").hide();
        $(".patient-create").show();
        $("#patient-searchbutton").show();
    })

    $(document).on("click", "#patient-submit", function () { 
        var patient_name = $("#patient-name").val()
        var patient_data = $("#patient-data").val()
        if (patient_name != "" && patient_data != "") {
            document.getElementById("patient-name").value = ""
            document.getElementById("patient-data").value = ""
            $.post('https://magni-emsmdt/create', JSON.stringify({name: patient_name, data: patient_data}));
        } else {
        }
    })

    $(document).on("click", "#searchicon", function () { 
        var input = $("#patient-searchs").val()
        if (input != "") {
            $.post('https://magni-emsmdt/search', JSON.stringify({input: input}));
        }
    })

    $(document).on("click", ".close-info", function (e) {
        $(".patient-info").css("height", "0%");   
        setTimeout(() => {
            $(".patient-info").fadeOut(250);
            document.getElementById("#patient-searchs").value = ""
        }, 500);
    });

    function Search(result) { 
        if (result) {
            $(".header").remove();
            $(".patient-context").remove();
            for (i = 0; i < result.length; i++) {
                $(".patient-info").append('<div class="header"><p id="patient-fullname"> <b>Name</b> <br>' + result[i].name + '</p><p id="patient-date"> <b>Date</b> <br> ' + result[i].date + ' </p></div><div class="patient-context"><p class="context" id="context">'+ result[i].data +'</p></div>');
                $(".patient-info").fadeIn(250);
                $(".patient-info").css("height", "55%");  
            }  
        }
    }

    $(document).on("click", "#close", function (e) {
        close()
    });

    document.onkeydown = function (data) {
        if (data.which == 27) { 
            close()
            return
        } 
    };

    function close() { 
        $.post('https://magni-emsmdt/close', JSON.stringify({display: false}));
        $(".container").fadeOut(500);
    }
})