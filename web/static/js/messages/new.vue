<template lang="html">
  <div>
    <div class="messages" id="message-scroll">
      <div class="col-sm-12" v-for="message in this.messages">
        <h5>{{message.email}}</h5>
        <span v-for="m in message.messages" v-html="m.text"></span>
      </div>
    </div>
    <div class="message-input">
      <textarea id="textarea" rows="1" class="form-control" v-on:keydown.enter="postMessages($event)" v-model="message"></textarea>
    </div>
  </div>
</template>

<script>
import socket from '../socket'

export default {
  data() {
    return {
      channel: socket.channel(`channels:${this.channelId}`),
      message: "",
      messages: JSON.parse(this.stringMessages)
    }
  },
  props: {
    channelId: String,
    csrf: String,
    userToken: String,
    stringMessages: String
  },
  methods: {
    init() {
      socket.params = { token: this.userToken }
      socket.connect();
      this.channel.join()
        .receive("ok", resp => console.log("joined!"))
        .receive("error", resp => console.log("failed"))
      this.receiveMessage()
    },
    postMessage() {
      let payload = {text: this.message, channel_id: this.channelId}
      this.channel.push("new_message", payload)
        .receive("error", e => console.log(e))
      this.message = ""
    },
    postMessages(event) {
      if (event.shiftKey) {
        $("#textarea")[0].rows ++
      } else {
        event.preventDefault();
        this.postMessage()
        $("#textarea")[0].rows = 1
      }
    },
    receiveMessage() {
      this.channel.on("new_message", (resp) => {
        let prev = this.messages[this.messages.length - 1]
        if (this.messages.length === 0 || prev.email !== resp.user.email) {
          this.messages.push({email: resp.user.email, messages: [resp]})
        } else {
          prev.messages.push(resp)
        }
        this.scroll()
      })
    },
    scroll() {
      let message = document.getElementById('message-scroll')
      message.scrollTop = message.scrollHeight
    }
  },
  beforeMount() {
    this.init();
  },
  mounted() {
    this.scroll()
  }
}
</script>

<style lang="scss">
  #textarea {
    resize: none;
  }
</style>
