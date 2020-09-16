const Helpers = {}

Helpers.clearInput = function(id){
    const input = document.getElementById(id)
    input.value = ''
}

Helpers.removeElement = function(id){
    document.getElementById(id).remove()
}


window.Helpers = Helpers
