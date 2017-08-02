<template lang="html">
  <div>
    <div class="messages" id="message-scroll">
      <div class="col-sm-12" v-for="message in this.messages">
        <h5>{{message.email}}</h5>
        <span v-for="m in message.messages" v-html="m.text"></span>
      </div>
    </div>
    <div class="message-input">
      <textarea id="textarea" rows="1" class="pull-right form-control" v-on:keydown.enter="postMessages($event)" v-model="message"></textarea>
      <div class="pull-left add-snippet" data-toggle="modal" data-target="#snippet">
        <span class="fa fa-lg fa-plus snippet-plus"></span>
      </div>
    </div>
    <file></file>
  </div>
</template>

<script>
import socket from '../socket'
import File from './file'

export default {
  data() {
    return {
      channel: socket.channel(`channels:${this.channelId}`),
      message: '',
      messages: JSON.parse(this.stringMessages),
      language: ''
    }
  },
  props: {
    channelId: String,
    csrf: String,
    userToken: String,
    stringMessages: String
  },
  watch: {
    messages: {
      handler: function() {
        setTimeout(() => {
          this.scroll()
        }, 100)
      },
      deep: true
    }
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
      let payload = {text: this.message, language: this.language, channel_id: this.channelId}
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
    this.$on('post-message', (msg) => {
      this.message = msg
      this.postMessage()
    })
  },
  components: {
    File
  }
}
</script>

<style lang="scss">
  #textarea {
    resize: none;
    width: 95%;
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
  }

  .add-snippet {
    border: 2px solid #b4bcc2;
    width: 5%;
    padding: 9px;
    border-top-left-radius: 5px;
    border-bottom-left-radius: 5px;
  }

  .snippet-plus {
    margin-left: 5px;
  }
</style>
