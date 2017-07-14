<template>
  <div>
    <h3>New Channel <span class="fa fa-plus fa-success" v-on:click.prevent="displayInput"></span></h3>
    <div class="row">
      <div class="col-sm-6">
        <ul class="list-inline" v-if="isDisplayed">
          <li><input type="text" class="form-control" v-model="name"></li>
          <li><button class="btn btn-success" v-on:click="saveChannel">Save</button></li>
        </ul>
        <p class="error-text" v-if="isInvalid">Please fill out a name</p>
        <ul class="list-unstyled">
          <li v-for="channel in channels">
            <h4>{{ channel.name }}</h4>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    data () {
      return {
        isDisplayed: false,
        csrf: document.querySelector("meta[name=csrf]").content,
        isInvalid: false,
        channels: JSON.parse(this.stringChannels)
      }
    },
    props: {
      stringChannels: String
    },
    methods: {
      displayInput() {
        this.isDisplayed = true;
      },
      saveChannel() {
        var self = this;
        if (this.isNameValid()) {
          this.isInvalid = false;
          $.ajax({
            url: "/channels",
            method: "POST",
            headers: { "X-CSRF-TOKEN": this.csrf },
            data: {channel: {name: this.name }},
            success: function(response) {
              self.name = "";
              self.isDisplayed = false;
              self.channels.unshift(response);
            },
            error: function(response) {
              self.isInvalid = true;
            }
          })
        } else {
          this.isInvalid = true;
        }
      },
      isNameValid() {
        return (typeof this.name !== "undefined" && this.name.length !== 0);
      }
    }
  }
</script>
