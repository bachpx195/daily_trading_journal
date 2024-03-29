import Vue from 'vue'
import Vuetify from 'vuetify'
import Vuex from 'vuex';
import 'vuetify/dist/vuetify.min.css'
import vSelect from 'vue-select'
import Select from './components/select'

Vue.use(Vuetify)
Vue.use(Vuex)
Vue.component('v-select', vSelect)

document.addEventListener('DOMContentLoaded', () => {
  let element = document.getElementById("select_custom")
  let options = JSON.parse(decodeURIComponent(element.getAttribute('data-merchandises')))
  let selected = element.getAttribute('data-seleted').slice(1,-1).split(',')

  const app = new Vue({
    vuetify: new Vuetify(),
    render(h) {
      return h(Select, {
        props: {
          options: options,
          selected: selected
        }
      })
    }
  }).$mount()
  document.getElementById("select_custom").appendChild(app.$el)
})
