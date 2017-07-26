<template lang="html">
  <div>
    <span class="fa fa-plus fa-success" v-if="!showInvite" v-on:click="displayInput"></span>
    <div v-if="showInvite">
      <input type="text" class="form-control" v-if="showInvite" v-model="email">
      <button class="btn btn-xs btn-info" v-on:click="invite">Invite</button>
    </div>
    <div class="alert invite-alert" v-bind:class="{ 'alert-success': isSuccess, 'alert-danger': isError }"
                       v-if="isSuccess || isError">
      {{this.message}}
    </div>
    <ul class="list-unstyled names-list">
      <li v-for="name in names">
        {{name}}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showInvite: false,
      email: '',
      message: 'what',
      isSuccess: false,
      isError: false,
      names: []
    }
  },
  props: {
    channelId: String,
    csrf: String
  },
  methods: {
    displayInput() {
      this.showInvite = !this.showInvite
    },
    closeAlert() {
      setTimeout(() => {
        this.message = ''
        this.isSuccess = false
        this.isError = false
      }, 3000)
    },
    invite() {
      let self = this;
      $.ajax({
        url: `/invite/${this.channelId}`,
        method: "PUT",
        headers: { "X-CSRF-TOKEN": this.csrf },
        data: {invite: {email: this.email }},
        success: function(response) {
          self.email = ''
          self.showInvite = false
          self.message = response.message
          self.names.push(response.name)
          self.isSuccess = true
          self.isError = false
          self.closeAlert()
        },
        error: function(response) {
          self.message = response.responseJSON.message
          self.isSuccess = false
          self.isError = true
          self.closeAlert()
        }
      })
    }
  }
}
</script>

<style lang="css">
  .invite-alert {
    margin: 20px 0;
  }

  .names-list {
    margin-bottom: -2px;
  }
</style>
