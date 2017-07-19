<template lang="html">
  <div>
    <div class="messages">
      <div class="col-sm-12" v-for="message in this.messages">
        <h4>{{message.email}}</h4>
        <p v-for="m in message.messages">{{m.text }}</p>
      </div>
    </div>
    <div class="message-input">
      <input type="text" class="form-control" v-on:keyup.enter="postMessage" v-model="message">
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
    receiveMessage() {
      this.channel.on("new_message", (resp) => {
        let prev = this.messages[this.messages.length - 1]
        if (prev.email == resp.user.email) {
          prev.messages.push(resp)
        } else {
          this.messages.push({email: resp.user.email, messages: [resp]})
        }
      })
    }
  },
  beforeMount() {
    this.init();
  }
}
</script>
