import { Controller } from 'stimulus'

let map
let markers = []
let idx = 0
let data
export default class extends Controller {
    initialize() {
        this.element[this.identifier] = this
        data = window.MapData.getData()
        map = window.MapData.getMap()
        console.log('%c This is now in stimulus controller', 'color: blue;')
        console.log(map)
        console.log(data)

        this.addMarkers(data)
    }
    addMarkers(data) {
        data.forEach((item) => {
            this.addMarker(item.lat, item.long, item.url, item.index)
        })
    }
    addMarker(latitude, longitude, url, index) {
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
            zIndex: index,
        })
        idx = index
        markers.push(marker)
    }

    center() {
        const latitude = this.data.get('latitude')
        const longitude = this.data.get('longitude')
        let marker = this.getMarker(latitude, longitude)
        marker = this.stackOnTop(marker)
        map.panTo(marker.position)
    }

    stackOnTop(marker) {
        idx = idx + 1
        marker.zIndex = idx
        console.log('%c The following is the zIndex', 'color: red')
        console.log(idx)
        return marker
    }

    getMarker(latitude, longitude) {
        let tmp

        markers.forEach((item) => {
            if (item.position.lat() == latitude && item.position.lng() == longitude) {
                tmp = item
            }
        })
        return tmp
    }
}
