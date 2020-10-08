const Photos = {}

Photos.updateCount = function () {
    const count = document.getElementById('count')
    let num = parseInt(count.textContent)
    num = num - 1
    count.textContent = num
}

window.Photos = Photos
