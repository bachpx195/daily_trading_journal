<template>
    <div>
      {{this.handleEdit}}
      <v-select multiple :options="Object.values(options).map(option => option['slug'])" />
    </div>
</template>

<script>
import 'vue-select/dist/vue-select.css';

export default {
  props:['options'],
  data: function() {
    return {
      message: "Hello Vue!"
    };
  },
  computed  : {
    handleEdit(){
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
