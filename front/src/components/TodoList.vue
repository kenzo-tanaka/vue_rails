<template>
  <div>
    <div class="field is-grouped mt-6">
      <p class="control is-expanded">
        <input v-model="todo.title" class="input" type="text" placeholder="Add Todo">
      </p>
      <p class="control">
        <a class="button is-link" @click="createTodo">
          Add
        </a>
      </p>
    </div>
    <div class="content">
      <ul v-for="todo in todos" :key="todo.id">
        <li>
          {{ todo.title }}
          <button @click="openModal(todo)">Edit</button>
          <button @click="destroyTodo(todo.id)">Delete</button>
        </li>
      </ul>
    </div>

    <!-- Modal -->
    <!-- TODO: 別コンポーネントに切り出したい -->
    <div v-bind:class="{ 'is-active': modalActive }" class="modal">
      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="field is-grouped mt-6">
          <p class="control is-expanded">
            <input v-model="editTodo.title" class="input" type="text">
          </p>
          <p class="control">
            <a class="button is-link" @click="updateTodo(editTodo.id)">
              update
            </a>
          </p>
        </div>
      </div>
      <button @click="closeModal" class="modal-close is-large" aria-label="close"></button>
    </div>

  </div>
</template>


<script>
import axios from 'axios';

export default {
  name: 'TodoList',
  data() {
    return {
      todos: [],
      todo: {
        title: ''
      },
      modalActive: false,
      editTodo: {
        id: '',
        title: ''
      },
    }
  },
  mounted() {
    axios
      .get(`${process.env.API_ENDPOINT}/v1/todos`)
      .then(res => {
        this.todos = res.data;
      })
  },
  methods: {
    createTodo: function() {
      axios
        .post(`${process.env.API_ENDPOINT}/v1/todos`, this.todo)
        .then(res => {
          this.updateTodos();
          this.todo.title = '';
        })
    },
    updateTodos: function() {
      axios
        .get(`${process.env.API_ENDPOINT}/v1/todos`)
        .then(res => {
          this.todos = res.data;
        })
    },
    destroyTodo: function(id) {
      axios
        .delete(`${process.env.API_ENDPOINT}/v1/todos/${id}`)
        .then(res => {
          this.updateTodos();
        })
    },
    updateTodo: function(id) {
      axios
        .patch(`${process.env.API_ENDPOINT}/v1/todos/${id}`, this.editTodo)
        .then(res => {
          this.modalActive = false;
          this.updateTodos();
        })
    },
    openModal: function(todo) {
      this.editTodo = todo;
      this.modalActive = true;
    },
    closeModal: function() {
      this.editTodo = '';
      this.modalActive = false;
    }
  }
}
</script>
