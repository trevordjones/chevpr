<template lang="html">
  <div>
    <div class="messages">
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
      message: ""
    }
  },
  props: {
    channelId: String,
    csrf: String,
    userToken: String
  },
  methods: {
    init() {
      socket.params = { token: this.userToken }
      socket.connect();
      this.channel.join()
        .receive("ok", resp => console.log("joined!"))
        .receive("error", resp => console.log("failed"))
      this.channel.on("ping", ({count}) => console.log("PING", count) )
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
        console.log(resp)
      })
    }
  },
  beforeMount() {
    this.init();
  }
}
</script>
