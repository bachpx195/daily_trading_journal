import Vue from 'vue'
import Vuetify from 'vuetify'
import Vuex from 'vuex';
import 'vuetify/dist/vuetify.min.css'
import Select from './components/select'

Vue.use(Vuetify)
Vue.use(Vuex)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    vuetify: new Vuetify(),
    render: h => h(Select)
  }).$mount()
  document.getElementById("select_custom").appendChild(app.$el)
})
