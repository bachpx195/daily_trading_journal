<template>
  <div id="app">
    <v-app>
      <broad/>
    </v-app>
  </div>
</template>

<script>
import Broad from "./packs/components/kanban_broads/Board";
export default {
  data: function() {
    return {
      message: "Hello Vue!"
    };
  },
  components: {
    Broad
  }
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
