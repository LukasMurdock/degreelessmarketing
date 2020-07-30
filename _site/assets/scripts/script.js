


function dropdownMenuClick(element) {
    console.log("FIRE");
    element = element.getElementsByClassName("dropdown-content")[0]

    if (element.style.display === "none") {
        console.log("none to grid")
        element.style.display = "grid";
      } else {
        console.log("grid to none")
        element.style.display = "none";
      }

    // element.getElementsByClassName("dropdown-content")[0].style.display = "grid";
}

function dropdownEnter(element) { 
console.log("Enter")
element.getElementsByClassName("dropdown-content")[0].style.display = "grid";
}

function dropdownLeave(element) { 

    console.log("Leave")
    element.getElementsByClassName("dropdown-content")[0].style.display = "none";
}