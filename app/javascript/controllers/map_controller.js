// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from 'stimulus'

let map
let markers = []
let idx = 0
export default class extends Controller {
    connect() {
        this.element[this.identifier] = this
    }

    initMap(latitude, longitude) {
        map = new google.maps.Map(document.getElementById('map'), {
            center: { lat: latitude, lng: longitude },
            zoom: 12,
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
        let tmp

        markers.forEach((item) => {
            if (item.position.lat() == latitude && item.position.lng() == longitude) {
                tmp = item
            }
        })
        idx = idx + 1
        tmp.zIndex = idx
        map.panTo(tmp.position)
    }
    // TODO: why can't I call this method here?
    // center() {
    //     const latitude = this.data.get('latitude')
    //     const longitude = this.data.get('longitude')
    //     map.panTo(this.getMarker().position)
    // }

    // getMarker(latitude, longitude) {
    //     let tmp

    //     markers.forEach((item) => {
    //         if (item.position.lat() == latitude && item.position.lng() == longitude) {
    //             tmp = item
    //         }
    //     })
    //     return tmp
    // }
}
