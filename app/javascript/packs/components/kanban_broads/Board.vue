<template>
   <div class="row board">
    <list v-for="(listItem, index) in lists" :key="index"
        :list_name = 'listItem.name'
        :list_description = 'listItem.description'
        :header_color="listItem.header_color"
        item_text = 'default item'
        :lists = 'lists'
        :list_items.sync = "items">
    </list>
  </div>
</template>

<script>
import list from "./List"
export default {
  components: {
    list: list
  },
  data(){

    return {

      lists:[
        { name:'todo',description:'To Do',header_color:'bg-info'},
        { name:'doing',description:'Doing',header_color:'bg-warning'},
        { name:'done',description:'Done',header_color:'bg-success'},
      ],

      items: [
        { id: 1, text: 'Build the feature #1', list: 'todo' },
        { id: 2, text: 'Test the feature #1', list: 'todo' },
        { id: 3, text: 'Commit feature #1 to the repository', list: 'todo' },
        { id: 4, text: 'Deploy the feature #1', list: 'todo' },
        { id: 5, text: 'Build the demo app', list: 'doing' },
        { id: 6, text: 'Put in some sample data in app', list: 'doing' },
        { id: 7, text: 'Test the app before launching', list: 'doing' },
        { id: 8, text: 'Set up app landing page ', list: 'done' },
        { id: 9, text: 'Send out email invitations to the subscribers', list: 'done' },
      ],
    }
  }
};
</script>


<style lang="scss" scoped>
.board {
  margin-top:5px;
}
</style>
