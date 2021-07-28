<template>
    <div>
      <div v-for="option in selected_options" :key="option" style="display: none">
        <input name='idea[idea_merchandises][]' :value="findBySlug(option)">
      </div>
      <v-select
        multiple
        :value="selected_options"
        name='idea[idea_merchandise]'
        :options="select_options"
        @input="option => updateOption(option)"
      />
    </div>
</template>

<script>
import 'vue-select/dist/vue-select.css';

export default {
  props:['options', 'selected'],
  data: function() {
    return {
      select_options: Object.values(this.options).map(option => option['slug']),
      selected_options: Object.values(this.options.filter(option => Object.values(this.selected).includes(option['id'].toString()))).map(option => option['slug'])
    };
  },
  methods: {
    updateOption (option) {
      this.selected_options = option
    },
    findBySlug (slug) {
      return this.options.find(option => option['slug'] === slug).id
    }
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
