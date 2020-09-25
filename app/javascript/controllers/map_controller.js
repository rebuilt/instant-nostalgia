import { Controller } from 'stimulus'

let map
let markers = []
let topIndex = 0
let data
let hasInitialized = false
export default class extends Controller {
    initialize() {
        this.element[this.identifier] = this
        if (hasInitialized === false) {
            map = window.MapData.getMap()
            data = window.MapData.getData()
            this.addMarkers(data)
            hasInitialized = true
        }
    }

    addMarkers(data) {
        data.forEach((item) => {
            this.addMarker(item.lat, item.long, item.url, item.id)
        })
    }

    addMarker(latitude, longitude, url, id) {
        topIndex = topIndex + 1
        const image = {
            url: url,
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(0, 32),
        }

        const marker = new google.maps.Marker({
            position: { lat: latitude, lng: longitude },
            map: map,
            icon: image,
            zIndex: topIndex,
            id: id,
        })

        const title = document.createElement('p')
        title.textContent = 'image clicked'
        const infowindow = new google.maps.InfoWindow({
            content: title,
        })
        google.maps.event.addListener(marker, 'click', function () {
            let mapController = document.getElementById('map').map
            console.log(mapController)
            mapController.stackOnTop(marker)
            map.panTo(marker.position)
        })
        markers.push(marker)
    }

    center() {
        const latitude = this.data.get('latitude')
        const longitude = this.data.get('longitude')
        const id = this.data.get('id')
        let marker = this.getMarker(id)
        marker = this.stackOnTop(marker)
        map.panTo(marker.position)
    }

    stackOnTop(marker) {
        topIndex = topIndex + 1
        marker.zIndex = topIndex
        return marker
    }

    getMarker(id) {
        let tmp

        markers.forEach((item) => {
            if (item.id == id) {
                tmp = item
            }
        })
        return tmp
    }
}
