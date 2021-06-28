import Vue from 'vue'
import Vuetify from 'vuetify'
import Vuex from 'vuex';
import 'vuetify/dist/vuetify.min.css'
import App from '../app.vue'

Vue.use(Vuetify)
Vue.use(Vuex)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    vuetify: new Vuetify(),
    render: h => h(App)
  }).$mount()
  document.getElementById("main").appendChild(app.$el)

  console.log(app)
})
