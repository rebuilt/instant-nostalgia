import { Controller } from 'stimulus'

let map
let markers = []
let topIndex = 0
let hasInitialized = false
export default class extends Controller {
    initialize() {
        this.element[this.identifier] = this
        if (hasInitialized === false) {
            map = window.MapData.getMap()
            let data = window.MapData.getData()
            this.addMarkers(data)
            hasInitialized = true
        }
    }

    addMarkers(data) {
        data.forEach((dataItem) => {
            let marker = this.addMarkerToMap(dataItem)
            let behavior = this.createBehavior(marker, dataItem)
            this.addBehavior(marker, behavior)
            markers.push(marker)
        })
    }

    addMarkerToMap(data) {
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

    createBehavior(marker, data) {
        let behavior = function () {
            const mapController = document.getElementById('map').map
            mapController.stackOnTop(marker)
            map.panTo(marker.position)

            const modalController = document.getElementById('modal').modal
            const content = modalController.createModal(data)
            modalController.show(content)
        }
        return behavior
    }

    addBehavior(marker, behavior) {
        google.maps.event.addListener(marker, 'click', behavior)
    }

    center() {
        const id = this.data.get('id')
        let marker = this.getMarker(id)
        marker = this.stackOnTop(marker)
        marker.setVisible(true)
        map.panTo(marker.position)
    }

    stackOnTop(marker) {
        topIndex = topIndex + 1
        marker.zIndex = topIndex
        return marker
    }

    getMarker(id) {
        return markers.find((item) => item.id == id)
    }
}
