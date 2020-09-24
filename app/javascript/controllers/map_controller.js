import { Controller } from 'stimulus'

let map
let markers = []
let idx = 0
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
            this.addMarker(item.lat, item.long, item.url, item.index)
        })
    }
    addMarker(latitude, longitude, url, index) {
        console.log(index)
        console.log(typeof index)
        idx = idx + index
        const image = {
            url: url,
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(0, 32),
        }

        const shape = {
            coords: [1, 1, 1, 20, 18, 20, 18, 1],
            type: 'poly',
        }

        const marker = new google.maps.Marker({
            position: { lat: latitude, lng: longitude },
            map: map,
            icon: image,
            shape: shape,
            zIndex: idx,
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
