import { Controller } from "@hotwired/stimulus";

let ymapsPromise = null;
function loadYandex(apiKey) {
  if (window.ymaps) return Promise.resolve(window.ymaps);
  if (ymapsPromise) return ymapsPromise;

  const qs = new URLSearchParams({ lang: "ru_RU" });
  if (apiKey) qs.set("apikey", apiKey);

  ymapsPromise = new Promise((resolve, reject) => {
    const s = document.createElement("script");
    s.src = `https://api-maps.yandex.ru/2.1/?${qs.toString()}`;
    s.async = true;
    s.onload = () => window.ymaps.ready(() => resolve(window.ymaps));
    s.onerror = () => reject(new Error("Не удалось загрузить Яндекс.Карты"));
    document.head.appendChild(s);
  });
  return ymapsPromise;
}

export default class extends Controller {
  static values = {
    lat: Number,
    lon: Number,
    zoom: { type: Number, default: 13 },
    marker: { type: Boolean, default: true },
    draggable: { type: Boolean, default: false },
    apiKey: String
  };

  async connect() {
    const ymaps = await loadYandex(this.apiKeyValue);
    this.map = new ymaps.Map(this.element, {
      center: [this.latValue, this.lonValue],
      zoom: this.zoomValue,
      controls: ["zoomControl"]
    }, { suppressMapOpenBlock: true });

    if (this.markerValue) {
      this.pin = new ymaps.Placemark(
        [this.latValue, this.lonValue],
        {},
        { draggable: this.draggableValue, preset: "islands#redIcon" }
      );
      this.map.geoObjects.add(this.pin);

      if (this.draggableValue) {
        this.pin.events.add("dragend", () => {
          const [lat, lon] = this.pin.geometry.getCoordinates();
          this.dispatch("moved", { detail: { lat, lon } });
        });
      }

      this.map.events.add("click", (e) => {
        if (!this.draggableValue || !this.pin) return;
        const coords = e.get("coords");
        this.pin.geometry.setCoordinates(coords);
        const [lat, lon] = coords;
        this.dispatch("moved", { detail: { lat, lon } });
      });
    }

    setTimeout(() => this.map.container.fitToViewport(), 0);
  }

  disconnect() { if (this.map) this.map.destroy(); }

  latValueChanged() { this._recenter(); }
  lonValueChanged() { this._recenter(); }
  zoomValueChanged() { if (this.map) this.map.setZoom(this.zoomValue); }

  _recenter() {
    if (!this.map) return;
    const c = [this.latValue, this.lonValue];
    this.map.setCenter(c, this.zoomValue);
    if (this.pin) this.pin.geometry.setCoordinates(c);
  }
}
