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
            let marker = this.addMarker(item)
            this.addBehavior(marker, item)
            markers.push(marker)
        })
    }

    addMarker(data) {
        topIndex = topIndex + 1
        const image = {
            url: data.img_sm,
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(0, 32),
        }

        const marker = new google.maps.Marker({
            position: { lat: data.lat, lng: data.long },
            map: map,
            icon: image,
            zIndex: topIndex,
            id: data.id,
        })
        return marker
    }

    addBehavior(marker, data) {
        google.maps.event.addListener(marker, 'click', function () {
            let mapController = document.getElementById('map').map
            console.log(mapController)
            mapController.stackOnTop(marker)
            map.panTo(marker.position)
            const modal = document.getElementById('modal')
            const content = modal.modal.createModal(data)
            modal.appendChild(content)
            modal.modal.show()
        })
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
