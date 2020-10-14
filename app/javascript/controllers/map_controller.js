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
            this.attachZoomListener()
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

    attachZoomListener() {
        map.addListener('zoom_changed', () => {
            let size = 200
            switch (map.zoom) {
            case 13:
                size = 150
                break
            case 12:
                size = 100
                break
            case 11:
                size = 50
                break
            case 10:
            case 9:
            case 8:
            case 7:
            case 6:
            case 5:
            case 4:
            case 3:
            case 2:
            case 1:
            case 0:
                size = 20
                break
            }
            console.log(size)
            console.log(map.zoom)
            markers.forEach(
                (marker) => (marker.icon.size = new google.maps.Size(size, size))
            )
        })
    }
}
